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
- Move file checkout_page.blade.php to folder path: resources/views/
- run command `php artisan make:controller PaymentController` then add code below into this file:
    ```
    /**
    * checkout by a client [cards]
    */
    public function checkoutPage(Request $request)
    {
        $request->validate([
            'hash' => 'required',
            'tran_id' => 'required|numeric',
            'amount' => 'required|numeric',
            'firstname' => 'required',
                'lastname' => 'required',
            'phone' => 'required|regex:/^([0-9\s\-\+\(\)]*)$/min:7',
            'email' => 'required|email',
            'payment_option' => 'required',
            'items' => 'required',
            'shipping' => 'required|numeric',
        ]);
            $hash = $request->hash;
        $tran_id = $request->tran_id;
        $amount = $request->amount;
        $firstname = $request->firstname;
        $lastname = $request->lastname;
        $phone = $request->phone;
        $email = $request->email;
        $payment_option = $request->payment_option;
        $items = $request->items;
        $shipping = $request->shipping;
        $apiUrl = PayWayApiCheckout::getApiUrl
        
        return view('checkout_page', [
            'hash' => str_replace(" ", "", $hash),
            'tran_id' => $tran_id,
            'amount' => $amount,
            'firstname' => $firstname,
            'lastname' => $lastname,
            'phone' => $phone,
            'email' => $email,
            'payment_option' => $payment_option,
            'items' => str_replace(" ", "", $items),
            'shipping' => $shipping,
            'apiUrl' => $apiUrl,
        ]);
    }
    ```
- add code below to web.php
    ```
    Route::group(['prefix' => 'payment'], function () {
        Route::get('/checkout_page', 'UserController@checkoutPage');
    })
    ```
- checkoutApiUrl is https://yourdomain/payment/checkout_page.php   