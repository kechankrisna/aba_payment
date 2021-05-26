## Configuration for php code

### PHP vanila

- Download file from php_vanila folder, then you must have two files which are: [PayWayApiCheckout.php](php_vanila/PayWayApiCheckout.php) and [checkout_page.php](php_vanila/checkout_page.php). 
- Create a folder in root directory.
- Put these file in the this folder.
- `NOTE:` checkout_page.php path will be used as `checkoutApiUrl`
#### Example:
    - Create a folder name payment in root directory of php project.
    - checkoutApiUrl is https://yourdomain/payment/checkout_page.php 

### PHP Laravel
- download file from php_laravel folder, then you must have two files which are: [PayWayApiCheckout.php](php_laravel/PayWayApiCheckout.php) and [checkout_page.blade.php](php_laravel/checkout_page.blade.php).
- Move file PayWayApiCheckout.php to folder name: app
- Move file checkout_page.blade.php to folder path resources/views/