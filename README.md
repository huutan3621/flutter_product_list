# Flutter Product List

This project is a Flutter application for displaying and managing a list of products. It includes functionalities such as fetching products from an API, searching products, and managing favorite products.

## Getting Started

### Prerequisites

Ensure you have Flutter installed on your machine. You can download Flutter from [here](https://flutter.dev/docs/get-started/install).

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/huutan3621/flutter_product_list.git
    ```

2. **Navigate to the project directory:**

    ```bash
    cd flutter_product_list
    ```

3. **Install the dependencies:**

    ```bash
    flutter pub get
    ```

### Running the Application

To run the application on an emulator or physical device, use the following command:

```bash
flutter run
```

## Running Tests

This project includes unit tests for the `ApiService` class, which handles fetching products from the API. The tests ensure that the methods return the expected results.

### Test Cases

- **`fetchProducts` returns a list of products:** Tests if the `fetchProducts` method returns a list of products.
- **`fetchProductById` returns a product:** Tests if the `fetchProductById` method returns a product based on the given ID.
- **`searchProducts` returns a list of products:** Tests if the `searchProducts` method returns a list of products based on the search query.

### Running the Tests

To run the tests, use the following command:

```bash
flutter test test/product_test_cases.dart
```
