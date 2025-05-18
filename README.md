# 🎥 Quran Video Maker

A simple, beautiful way to create personalized Quran videos — select your reciter, verses, translation, and design, then sit back and let the app do the work.

Whether you're a content creator, educator, or just want to share the beauty of the Qur’an, this tool helps you turn verses into high-quality videos effortlessly.

🔗Contributers:
[@MuneerX](https://github.com/muneerx)
[@expertmars](https://github.com/expertmars)

---

## ✨ What You Can Do

- 🔍 **Pick a Surah and Ayah Range**  
  Choose any Surah and specify from which Ayah to which Ayah you'd like to generate a video.

- 🎧 **Select a Qari (Reciter)**  
  Choose from a range of well-known Qaris — perfect recitation synced with the text.

- 📝 **Customize Arabic Script**  
  Tailor the font, size, and style of the Arabic verse display — from classic Uthmani to modern scripts.

- 🌐 **Add Translation**  
  Display a translation in your preferred language. Choose the look, feel, and alignment that suits your video.

- 🎬 **One-Click Video Generation**  
  Once everything’s set, just click ‘Generate’ and let the app render a beautiful video where text and audio are synced smoothly.

---

## 🧩 Ideal For

- Islamic YouTubers, TikTok/Reel creators  
- Online Quran academies  
- Mosque media teams  
- Anyone who wants to share impactful, visually-rich Quran clips

---

## 📸 Sneak Peek

<img src="https://github.com/user-attachments/assets/501179d8-5a36-4516-be50-c8cf624793b9" width="160">
<img src="https://github.com/user-attachments/assets/c1570d7c-31b1-497c-aa79-d60d37c37383" width="160">
<img src="https://github.com/user-attachments/assets/4ec1b9ac-4405-48d7-81a8-1f3c22ac7aca" width="160">
<img src="https://github.com/user-attachments/assets/95920e3b-c343-4ccc-84f3-fce205b00b95" width="160">
<img src="https://github.com/user-attachments/assets/dc5b0a46-5403-4ce3-8ff1-c156f1602f24" width="160">

---

## 🚀 Getting Started

### Clone the Project

```bash
git clone https://github.com/expertmars/quranvideoapp.git
cd quran-video-creator

### Install Packages

```bash
npm install
# or
yarn
```

### Launch the App

```bash
npm run dev
```

The app should now be running at `http://localhost:3000`.

---

## 🛠 Tech Highlights

* **Frontend**: React + Tailwind CSS (or your frontend of choice)
* **Backend**: Node.js + Express
* **Video Engine**: FFmpeg handles video/audio merging and rendering
* **APIs/Content**: Quran.com APIs, Tanzil.net, and local resources
* **Font Support**: Madani, IndoPak, Amiri, and more
* **Output Format**: Full HD, with presets for Instagram, YouTube, TikTok

---

## 📁 Project Overview

```bash
quranvideoapp/
│
├── public/               # Fonts, assets
├── src/
│   ├── components/       # Reusable React components
│   ├── pages/            # Main pages (if using Next.js)
│   ├── api/              # API routes for surahs, qaris, translations
│   ├── utils/            # Sync helpers, data parsing, styling logic
│   └── renderer/         # FFmpeg video processing
```

---

## 🎯 What’s Next

* [x] Audio-text sync for Qari recitations
* [x] Font and layout customization
* [x] Support for multiple languages
* [x] Video backgrounds (image/video/gradient)
* [ ] Social media export presets (Reels, Shorts, etc.)
* [ ] Save & re-edit previous projects
* [ ] Deploy as a public app (optional SaaS)

---

## 🤝 How to Contribute  


If you'd like to improve this project — you're more than welcome! You can:

* Open an issue with suggestions or bugs
* Fork and create a pull request
* Share your ideas for new features

Before contributing, please read the [CONTRIBUTING.md](CONTRIBUTING.md) (coming soon).

---

## 📜 License

This project is open-source and licensed under the MIT License.
Feel free to use, remix, and build upon it.

---

## 🙌 Creator

Built with love and intention by Mubarak and Muneer (https://mubaraktech.com).
If you'd like to collaborate or offer feedback, feel free to reach out.

> *“We have certainly sent down the Qur'an, and We will surely guard it.”*
> — Surah Al-Hijr (15:9)
