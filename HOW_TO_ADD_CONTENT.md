# How to Add New Forms and Rewards

## Adding a New Form

Edit `lib/data/repositories/mock_forms_repository.dart`:

```dart
FormModel(
  id: 'new_form_id',
  title: 'Your Form Title',
  description: 'Brief description of what this form is about',
  rewardPoints: 100,  // Points awarded on completion
  estimatedTimeMinutes: 3,  // Estimated time to complete
  questions: [
    // TEXT Question (free text input)
    QuestionModel(
      id: 'q1',
      title: 'What do you think about X?',
      description: 'Optional helper text',
      type: QuestionType.TEXT,
      required: true,
    ),
    
    // RADIO Question (single choice)
    QuestionModel(
      id: 'q2',
      title: 'How often do you use Y?',
      type: QuestionType.RADIO,
      required: true,
      options: [
        OptionModel(id: 'daily', text: 'Daily'),
        OptionModel(id: 'weekly', text: 'Weekly'),
        OptionModel(id: 'monthly', text: 'Monthly'),
        OptionModel(id: 'never', text: 'Never'),
      ],
    ),
    
    // CHECKBOX Question (multiple choice)
    QuestionModel(
      id: 'q3',
      title: 'Which features do you use? (Select all)',
      type: QuestionType.CHECKBOX,
      required: false,
      options: [
        OptionModel(id: 'feature1', text: 'Feature 1'),
        OptionModel(id: 'feature2', text: 'Feature 2'),
        OptionModel(id: 'feature3', text: 'Feature 3'),
      ],
    ),
    
    // RATING Question (star rating)
    QuestionModel(
      id: 'q4',
      title: 'Rate your experience',
      type: QuestionType.RATING,
      required: true,
      minRating: 1,
      maxRating: 5,  // Default is 5 if not specified
    ),
  ],
),
```

## Adding a New Reward

Edit `lib/data/repositories/mock_rewards_repository.dart`:

```dart
RewardItemModel(
  id: 'reward_id',
  title: 'Your Reward Title',
  description: 'Brief description of the reward',
  cost: 500,  // Points required to redeem
  category: 'Gift Card',  // Category (displayed as badge)
  imageUrl: 'https://example.com/image.jpg',  // Optional
),
```

### Reward Categories Examples:
- Gift Card
- Voucher
- Physical Item
- Subscription
- Experience
- Digital Content

## Question Types Guide

### 1. TEXT
- Free text input field
- Use for: open-ended questions, feedback, comments
- **Properties:**
  - `required`: true/false

### 2. RADIO
- Single selection from options
- Use for: exclusive choices (pick one)
- **Properties:**
  - `required`: true/false
  - `options`: List of OptionModel

### 3. CHECKBOX
- Multiple selections from options
- Use for: non-exclusive choices (pick many)
- **Properties:**
  - `required`: true/false (at least one must be selected)
  - `options`: List of OptionModel

### 4. RATING
- Star rating (1-5 by default)
- Use for: satisfaction, quality ratings
- **Properties:**
  - `required`: true/false
  - `minRating`: minimum value (usually 1)
  - `maxRating`: maximum value (usually 5)

## Best Practices

### Forms:
1. **Keep forms short**: 3-5 questions is optimal
2. **Set realistic time estimates**: Users prefer transparency
3. **Balance reward points**: More questions = more points
4. **Use clear titles**: Users should immediately understand the question
5. **Add descriptions**: Help users understand what you're asking for
6. **Mix question types**: Variety keeps users engaged

### Rewards:
1. **Set fair costs**: 
   - Low effort (100-200 pts): Small rewards
   - Medium effort (300-500 pts): Moderate rewards
   - High effort (600-1200 pts): Premium rewards
2. **Clear descriptions**: Tell users exactly what they'll get
3. **Categorize properly**: Helps users find what they want
4. **Use appealing titles**: Make rewards sound exciting
5. **Add images (future)**: Visual rewards are more attractive

## Point Economy Guide

### Earning Points:
- Binary Card Swipe: ~50 points
- Golden Ticket Card: ~100 points
- Sponsored Card: ~75 points
- Survey Card: ~150 points
- Forms: 100-200 points (based on length)

### Spending Points:
- Small rewards: 250-350 points
- Medium rewards: 400-600 points
- Large rewards: 700-1200 points

**Tip:** Keep earning and spending balanced so users feel progress!

## Example: Adding a Product Feedback Form

```dart
FormModel(
  id: 'product_feedback',
  title: 'Product Feedback Survey',
  description: 'Help us improve our product with your valuable feedback',
  rewardPoints: 150,
  estimatedTimeMinutes: 4,
  questions: [
    QuestionModel(
      id: 'usage_frequency',
      title: 'How often do you use our product?',
      type: QuestionType.RADIO,
      required: true,
      options: [
        OptionModel(id: 'daily', text: 'Daily'),
        OptionModel(id: 'weekly', text: 'Weekly'),
        OptionModel(id: 'monthly', text: 'Monthly'),
        OptionModel(id: 'rarely', text: 'Rarely'),
      ],
    ),
    QuestionModel(
      id: 'satisfaction',
      title: 'Overall satisfaction with our product?',
      type: QuestionType.RATING,
      required: true,
      maxRating: 5,
    ),
    QuestionModel(
      id: 'features',
      title: 'Which features do you use most? (Select all)',
      type: QuestionType.CHECKBOX,
      required: false,
      options: [
        OptionModel(id: 'dashboard', text: 'Dashboard'),
        OptionModel(id: 'analytics', text: 'Analytics'),
        OptionModel(id: 'reports', text: 'Reports'),
        OptionModel(id: 'integrations', text: 'Integrations'),
      ],
    ),
    QuestionModel(
      id: 'improvement',
      title: 'What could we improve?',
      description: 'Be as specific as possible',
      type: QuestionType.TEXT,
      required: false,
    ),
  ],
),
```

## Testing Your Changes

After adding forms/rewards:

1. **Hot Reload**: Press `r` in the terminal
2. **Hot Restart**: Press `R` if hot reload doesn't work
3. **Navigate to Forms/Marketplace**: Test the new items
4. **Verify Points**: Check that points are awarded/deducted correctly

## Future: Real Backend Integration

When moving to a real backend:

1. Replace `MockFormsRepository` with API calls
2. Replace `MockRewardsRepository` with API calls
3. All models already support JSON serialization:
   ```dart
   final form = FormModel.fromJson(jsonData);
   final json = form.toJson();
   ```
4. Update repository implementations to use HTTP client
5. No changes needed to BLoCs or UI!

---

**That's it!** You can now easily add new forms and rewards to your app. 🎉
