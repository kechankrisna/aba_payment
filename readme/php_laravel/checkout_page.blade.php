<!DOCTYPE html>
<html lang="en">

<head>
    <title>CHECKOUT PAGE </title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <!--[if lt IE 9]> <![endif]-->
</head>

<style>
    .text-center{text-align:center;margin:auto;}
    .aba-modal, .aba-modal-content{
        margin: 0px auto !important;
        padding: 0px !important;
        width: 100vw !important;
        height: 100vh !important;
        background:white !important;
    }
    .aba-iframe{
        height: 100vh !important;
        max-height: 100vh !important;
    }
</style>


<body>

        <!— Popup Checkout Form —>
        <div id="aba_main_modal" class="aba-modal">

            <!— Modal content —>
                <div class="aba-modal-content">
                    <form method="POST" target="aba_webservice" action="{{$apiUrl}}" id="aba_merchant_request">
                        <input type="hidden" name="hash" value="{{$hash}}" id="hash" />
                        <input type="hidden" name="tran_id" value="{{$tran_id}}" id="tran_id" />
                        <input type="hidden" name="amount" value="{{$amount}}" id="amount" />
                        <input type="hidden" name="firstname" value="{{$firstname}}" />
                        <input type="hidden" name="lastname" value="{{$lastname}}" />
                        <input type="hidden" name="phone" value="{{$phone}}" />
                        <input type="hidden" name="email" value="{{$email}}" />
                        <input type="hidden" name="payment_option" value="{{$payment_option}}" />
                        <input type="hidden" name="items" value="{{$items}}" />
                        <input type="hidden" name="shipping" value="{{$shipping}}" />

                    </form>
                </div>
                <!— end Modal content—>
        </div>

        <!— End Popup Checkout Form —>

            <!— Make a copy this javaScript to paste into your site—>
                <!— Note: these javaScript files are using for only integration testing—>
                    <!-- <link rel="stylesheet" href="https://payway-staging.ababank.com/checkout-popup.html?file=css" />
                    <script src="https://payway-staging.ababank.com/checkout-popup.html?file=js&hide-close=1"></script> -->

                    <!— These javaScript files are using for only production —>
                        <link rel="stylesheet" href="https://payway.ababank.com/checkout-popup.html?file=css"/>
                        <script src="https://payway.ababank.com/checkout-popup.html?file=js&hide-close=1"></script>

                        <script>
                            $(document).ready(function(){
                                AbaPayway.checkout();
                            });
                        </script>
                        <!— End —>
</body>

</html>
