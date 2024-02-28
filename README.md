# Vehicle-Insurance-Risk-Prediction-and-Car-Clustering

## Main Objective
In the complex automotive industry, this project addresses the challenge of uncertainty about customer preferences. The focus is on the interplay between vehicle insurance considerations and customer preferences during the car purchasing process. The decision to purchase a vehicle involves the critical consideration of insurance costs, reflecting customers' diverse preferences, financial capacities, and risk tolerances. This project aims to bridge the gap by developing a classifier to predict insurance risk ratings and implementing a clustering algorithm to identify car clusters aligned with specific customer segments.

## Process

### Data Pre-processing
- **Data Source:** Kaggle dataset focusing on vehicle specifications, normalized losses, and assigned insurance risk.
- **Exploratory Data Analysis (EDA):**
  - Analyzed the distribution of insurance risk scores and addressed class imbalances.
  - Explored relationships between vehicle features and insurance risk, uncovering patterns related to customer preferences.

### Models Used
- **Classification Model:**
  - **Random Forest:** Employed as the primary model for its ability to handle complex relationships, achieving a test accuracy of 83.9%.
  - **Decision Tree:** Tested for interpretability but showed limitations with a test accuracy of 54.8%.
  - **Linear Discriminant Analysis (LDA):** Explored for interpretability, achieving a test accuracy of 77.4%.
  - **Gradient Boosting:** Investigated for handling class imbalance, achieving an 80.6% accuracy.

- **Clustering Algorithm:**
  - **K-Means Clustering:** Employed after feature selection using Random Forest feature importance.

### Success Metrics
- Employed accuracy metrics for classification and used the elbow method and silhouette score for clustering assessment.

## Final Results
### Classification Model
- **Random Forest:** Achieved a high test accuracy score of 83.9%, providing a powerful tool for data-driven decisions aligned with customer preferences.

### Clustering Algorithm:
Identified four distinct car clusters based on features.
1. **Versatile Affordability:** Neutral risk, moderate insurance cost, appeals to young professionals and families.

2. **Practical Reliability:** Slightly higher risk, average-sized sedans, targets practical customers seeking reliability.

3. **Luxury and Comfort:** Neutral risk, large sedans, appeals to affluent individuals seeking safety and comfort.

4. **Performance Enthusiasts:** Highest risk, larger-sized cars, convertibles, appeals to enthusiasts seeking luxury and performance.

## Business Value and Applicability of Results
- **Optimized Inventory:** Empowers dealerships to align their inventory with customer preferences, reducing inefficiencies in the purchasing process, and enables targeted inventory management based on predicted insurance risk ratings and identified customer clusters.
- **Enhanced Customer Satisfaction:** Tailored marketing strategies enhance customer satisfaction by offering vehicles that align with their preferences and insurance capabilities.

## Conclusion
This project, by predicting insurance risk ratings and identifying distinct car clusters, provides a comprehensive solution for dealerships to better understand and cater to customer preferences. The results empower dealerships to optimize their inventory, streamline the purchasing process, and enhance customer satisfaction by offering vehicles tailored to specific customer segments and their insurance considerations.
