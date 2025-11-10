/**
 * Telegram Userbot Manager
 * Support login OTP + 2FA langsung lewat chat
 * Auto-reconnect dan auto-load session saat start VPS
 */

const TelegramBot = require('node-telegram-bot-api');
const { TelegramClient } = require('telegram');
const { StringSession } = require('telegram/sessions');
const fs = require('fs');
const path = require('path');
const token = '8325298371:xxxx--FyX1mNlJ4';
const bot = new TelegramBot(token, { polling: true });

// folder penyimpanan sesi userbot
const sessionsDir = path.join(__dirname, 'userbots');
if (!fs.existsSync(sessionsDir)) fs.mkdirSync(sessionsDir);

const activeUserbots = new Map();

// 🔹 Fungsi auto-start semua userbot yang tersimpan
async function startUserBot(userId) {
  const sessionPath = path.join(sessionsDir, `${userId}.json`);
  if (!fs.existsSync(sessionPath)) return;
  const sessionData = JSON.parse(fs.readFileSync(sessionPath, 'utf8'));
  const client = new TelegramClient(
    new StringSession(sessionData.session),
    sessionData.apiId,
    sessionData.apiHash,
    { connectionRetries: 5 }
  );
  try {
    await client.connect();
    activeUserbots.set(userId, client);
    const me = await client.getMe();
    bot.sendMessage(userId, `✅ Userbot aktif sebagai ${me.username || me.firstName}`);
  } catch (e) {
    console.error(`Gagal jalankan userbot ${userId}:`, e);
    bot.sendMessage(userId, `❌ Gagal jalankan userbot kamu. Ketik .login untuk login ulang.`);
  }
}

// Auto load session saat VPS mulai
fs.readdirSync(sessionsDir).forEach(f => startUserBot(f.replace('.json', '')));

// 🔹 Fungsi bantu untuk tanya user di chat
async function ask(chatId, text) {
  const sent = await bot.sendMessage(chatId, text, { reply_markup: { force_reply: true } });
  return new Promise(resolve => {
    bot.onReplyToMessage(chatId, sent.message_id, msg => {
      resolve(msg.text.trim());
    });
  });
}

// 🔹 Login command
bot.onText(/^\.login$/, async msg => {
  const chatId = msg.chat.id;
  const sessionFile = path.join(sessionsDir, `${chatId}.json`);
  if (fs.existsSync(sessionFile)) {
    return bot.sendMessage(chatId, '⚠️ Kamu sudah login userbot. Gunakan `.stop` untuk logout.');
  }

  try {
    const apiId = parseInt(await ask(chatId, 'Masukkan API ID:'));
    const apiHash = await ask(chatId, 'Masukkan API HASH:');
    const phoneNumber = await ask(chatId, 'Masukkan nomor Telegram kamu (contoh: +628123...):');

    const stringSession = new StringSession('');
    const client = new TelegramClient(stringSession, apiId, apiHash, { connectionRetries: 5 });

    // Login dengan 2FA + OTP support
    await client.start({
      phoneNumber: async () => phoneNumber,
      phoneCode: async () => {
        bot.sendMessage(chatId, '📩 Kode OTP sudah dikirim ke Telegram kamu, cek di chat “Telegram”.');
        return await ask(chatId, 'Masukkan kode OTP:');
      },
      password: async () => {
        bot.sendMessage(chatId, '🔒 Akun kamu punya 2FA. Masukkan password 2FA (biarkan kosong jika tidak ada):');
        const pass = await ask(chatId, 'Password 2FA:');
        return pass || '';
      },
      onError: err => console.error('Login error:', err),
    });

    const me = await client.getMe();

    // Simpan sesi
    fs.writeFileSync(sessionFile, JSON.stringify({
      apiId,
      apiHash,
      session: stringSession.save(),
    }, null, 2));

    activeUserbots.set(chatId, client);
    bot.sendMessage(chatId, `✅ Login berhasil!\nUserbot aktif sebagai ${me.username || me.firstName}`);

  } catch (e) {
    console.error(e);
    bot.sendMessage(chatId, `❌ Login gagal: ${e.message}`);
  }
});

// 🔹 Stop / Logout userbot
bot.onText(/^\.stop$/, async msg => {
  const chatId = msg.chat.id;
  const sessionFile = path.join(sessionsDir, `${chatId}.json`);
  if (!fs.existsSync(sessionFile)) return bot.sendMessage(chatId, '❌ Belum ada userbot login.');

  const client = activeUserbots.get(chatId);
  if (client) {
    await client.disconnect().catch(() => {});
    activeUserbots.delete(chatId);
  }

  fs.unlinkSync(sessionFile);
  bot.sendMessage(chatId, '🛑 Userbot dihentikan dan sesi dihapus.');
});

console.log('🤖 Telegram Userbot Manager siap dijalankan di VPS!');
