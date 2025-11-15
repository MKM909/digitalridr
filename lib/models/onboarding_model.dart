class OnboardingItem {
  final String title;
  final String description;
  final String lottiePath; // For your "Skip" placeholder images
  final String? skipText; // Optional skip button text

  OnboardingItem({
    required this.title,
    required this.description,
    required this.lottiePath,
    this.skipText,
  });
}