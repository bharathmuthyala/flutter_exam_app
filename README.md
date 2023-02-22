# Flutter Exam App (Skillset Evaluation Project)

This project is for the Flutter skillset evaluation.

# Requirements

App contains 2 screens:
1. Home Screen - List of products
2. Detail Screen - Detail of product
Requirement:
1. User should be able to see the list of products on the home screen -
a. Initially, Home page should contain 20 rows.
Each row should contain “title”, “description”, “price” and ‘’ category.”
b. When user scrolls, app should load next 20 rows from repository.
2. When user tap on any of the Product row, App should navigate to a different page where
user can see the details of the product.
3. If user doesn’t have internet, app should load data from local store. (Offline support)

API Endpoints:
1. List 20 of products: https://dummyjson.com/products?limit=20
a. “limit” field can be used to fetch limited number of products.
b. “skip” can be used with limit option.
For example:
https://dummyjson.com/products?limit=20&skip=20
When we use limit ==20 and skip == 20, this will return products that starts from 21
– 40.

2. Detail of a particular product: https://dummyjson.com/products/1

Details:
1. Fetch the data from open apis: https://dummyjson.com/products
2. Save the response to local storage of your choice and update the ui according using state
management.

# Implementation

- ### Product Listing Screen
- ### Product Detail Screen
- ### Product Repository 
- ### Offline storage to load data using HIVE
- ### Simple BLoC testing code
- ### Simple Widget testing code

# Frameworks used

- [BLoC](https://pub.dev/packages/flutter_bloc) => BLoC is the state management framework used to render the widget upon the state changes.
- [Hive](https://pub.dev/packages/hive) => Hive is a lightweight and blazing fast key-value database written in pure Dart.
- [Infinite Scroll Pagination](https://pub.dev/packages/infinite_scroll_pagination) => Framework used to achieve pagination.
- [Mockito](https://pub.dev/packages/mockito) => This is used to generate mock objects for the Repositories, date models for Unit testing, integration testing etc.,
- [BLoC Test](https://pub.dev/packages/bloc_test) => Its a testing library used to test the BLoCs.
- [JSON Serializable](https://pub.dev/packages/json_serializable) => Framework used to generate data models to and from JSON.

