class BotService {
  static Map<String, String> stressQuestions = {
    // Greetings
    "hi": "Hi! 😊 How are you feeling today?",
    "hello": "Hello! 👋 How can I assist you?",
    "hii": "Hii! 🌟 Hope you're having a great day!",
    "hiii": "Hi! 😊 How are you feeling today?",
    "hey": "Hey there! 👋 Need help with something?",
    "how are you?": "I'm here to help you! 😊 How are you feeling?",

    // Common replies
    "fine": "Great to hear! 🎉 If you ever need to talk, I'm here.",
    "good": "That's awesome! 😃 Anything I can do for you?",
    "bad": "I'm here for you. 💙 Want to talk about what's bothering you?",
    "okay": "Alright! 😊 Let me know how I can assist you.",
    "not good":
        "I'm sorry to hear that. 💔 Do you want some stress-relief tips?",

    // Basic Stress-related Questions
    "name": "My name is StressEaseBot 🤖",
    "stress": "Stress is your body's reaction to any challenge or demand. 😟",
    "symptoms":
        "Common symptoms include headaches, sleep issues, irritability, and fatigue. 😴",
    "mental health":
        "It can cause anxiety, depression, and reduced concentration. 😓",
    "reduce stress":
        "Exercise 🏋️, meditation 🧘, deep breathing 😌, and proper sleep 🛌 help reduce stress.",
    "physical health":
        "Yes! 😞 Stress may cause high blood pressure, digestive issues, and heart problems. ❤️",
    "work stress":
        "Prioritize tasks ✅, take breaks ☕, and stay organized 📅 to reduce work stress.",

    // About the Stress Detection App
    "stress detection app":
        "It's an AI-based app 🤖 that detects stress levels using text and camera analysis.",
    " your app":
        "It's an AI-based app 🤖 that detects stress levels using text and camera analysis.",
    "how does app work":
        "It analyzes facial expressions 😐, answers to questions ❓, and activity levels 📊 to determine stress.",
    "app work":
        "It analyzes facial expressions 😐, answers to questions ❓, and activity levels 📊 to determine stress.",
    "features":
        "It includes MCQ-based stress analysis 📋, real-time camera detection 📷, activity suggestions 🏃, and progress tracking 📈.",
    "data safe":
        "Yes! 🔒 Your data is secure and used only for stress analysis.",
    "accuracy":
        "It uses AI models 🧠 to provide reliable stress level assessments based on multiple factors.",

    // One-word questions
    "thank you": "You're welcome! 😊 Stay stress-free! 🌸",
    "thanks": "No worries! ✨ Take care of yourself! 💙",
    "sleep":
        "Quality sleep is key to reducing stress. 💤 Try deep breathing before bed! 😌",
    "anxiety":
        "Deep breathing 😮‍💨, meditation 🧘, and exercise 🏋️ can help lower anxiety levels.",
    "diet":
        "A balanced diet 🍎🥦 rich in proteins, vitamins, and fiber helps manage stress.",
    "quotes":
        "Here's one: 'Do what you can, with what you have, where you are.' 🌟",
    "exercise":
        "Physical activity 🏃, yoga 🧘, and stretching 🏋️ help relieve stress.",
    "relax": "Try listening to calming music 🎵 or practicing mindfulness. 😌",

    // Fun and Encouraging Responses
    "joke":
        "😂 Sure! Why don't scientists trust atoms? Because they make up everything!",
    "motivation":
        "You're doing great! 💪 Keep going, and don't let stress hold you back! 🌟",
    "breathe": "Take a deep breath in... 😮‍💨 and out... 😌 Feel better?",
    "music":
        "Listening to relaxing music 🎶 can help reduce stress. Try it out!",
    "meditation":
        "Meditation 🧘 can help clear your mind and reduce stress. Want some tips?",
  };

  static String getResponse(String userInput) {
    String normalizedInput = userInput.toLowerCase().trim();

    // Check for exact match
    if (stressQuestions.containsKey(normalizedInput)) {
      return stressQuestions[normalizedInput]!;
    }

    // Check for partial keyword match
    for (String key in stressQuestions.keys) {
      if (normalizedInput.contains(key)) {
        return stressQuestions[key]!;
      }
    }

    // Default response if no match is found
    return "I'm not sure about that 🤔, but I can help with stress-related questions! Ask me anything about stress or the stress detection app. 😊";
  }
}
