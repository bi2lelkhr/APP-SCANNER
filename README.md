# Malicious URL Detector (Mobile App)

##  Overview
This mobile application allows users to **check whether a URL is safe or malicious**.  
Users can either:
- Enter the link manually  
- Scan a **QR code** containing the link  

The app uses a **Machine Learning model (Random Forest)** trained on a labeled dataset of safe and malicious websites, achieving **96% accuracy**.

---

##  Features
###  URL Input
- **Manual entry**: Paste or type the link into the app  
- **QR Code scanning**: Instantly scan a QR code to extract the link  

###  Security Check
- The app analyzes the link using a **Random Forest classifier**  
- The model is trained to detect **malicious patterns** such as phishing, suspicious domains, and unsafe redirections  
- The result is shown as:
  -  **Safe** (legitimate website)  
  -  **Malicious** (phishing / unsafe website)  

### 📊 Model Performance
- Algorithm: **Random Forest**  
- Accuracy: **96%**  
- Robust against overfitting and capable of handling many features  

---

## 🧠 Machine Learning Details
- **Training dataset**: Collection of labeled safe and malicious URLs  
- **Preprocessing**:
  - URL tokenization  
  - Feature extraction (length, domain, presence of IP, special characters, etc.)  
- **Model**: Random Forest Classifier  
- **Evaluation metric**: Accuracy (96%)  

---

##  Tech Stack
- **Mobile App**: Flutter (cross-platform, Android/iOS)  
- **Backend/ML**: Python (Flask API )  
- **Machine Learning**: scikit-learn (Random Forest)  

---

##  Usage
1. Open the app  
2. Either:
   - Paste a link manually  
   - Or scan a QR code  
3. The app will run the ML model and display whether the link is **safe** or **malicious**  

---

 

