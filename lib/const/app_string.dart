import 'package:get/get_navigation/src/root/internacionalization.dart';

// class AppString {
//   /// Invoice Screen
//   // static const invoiceText = "Invoice";
//   // static const signInText = "SignIn";
//   // static const signUpText = "SignUp";
//   // static const letsFillingBelowText =
//   //     "Let's get started by filling out the form below.";
//   // static const forgotPassText = "Forgot Password";
//   // static const continueWithGoogleText = "Continue with google";
//   // static const createAccText = "Create Account";
//
//   ///Home Screen
//   // static const paidText = "Paid";
//   // static const unPaidText = "Unpaid";
//   // static const allText = "All";
//   // static const invoicesText = "Invoices";
//   // static const amtText = "Amount";
//
//   ///Clients Screen
//   // static const clientText = "Clients";
//   // static const addNewClientText = "Add new client";
//   // static const fullNameText = "Full Name";
//   // static const emailText = "Email";
//   // static const phoneNumText = "Phone Number";
//   // static const addressText = "Address";
//   // static const cityText = "City";
//   // static const countryText = "Country";
//   // static const descText = "Description";
//   // static const saveText = "Save";
//   // static const plEnNameText = "Please Enter name";
//   // static const plEnEmailText = "Please Enter email";
//   // static const plEnPhoneText = "Please Enter Phone number";
//   // static const plEnAddressText = "Please Enter address";
//   // static const plEnCityText = "Please Enter city";
//   // static const selectCountryText = "Select Country";
//   // static const plEnDescText = "Please Enter Description";
//   // static const recentInvoiceText = "Recent Invoice";
//   // static const plAddBankDeatilText = "Please add your bank details";
//   // static const paymentDeatilText = "Payment Details";
//   //
//   // static const accountHoldText = "Account Holder's Name";
//   // static const acNumText = "Account Number";
//   // static const plEnAcNumText = "Please enter account number";
//   // static const bankNameText = "Bank Name";
//   // static const plEnBankNameText = "Please enter bank name";
//   // static const bankAddressText = "Bank Address";
//   // static const plEnBankAddressText = "Please enter bank address";
//   // static const ifscText = "IFSC Code";
//   // static const plEnIfscCodeText = "Please enter IFSC code";
//   // static const panNumText = "PAN Number";
//   // static const plEnPanNumText = "Please enter PAN number";
//
//   ///ProfileScreen
//   // static const profileText = "Profile";
//   // static const editUserText = "Edit User";
//   // static const accountText = "Account";
//   // static const paymentDetailText = "Payment Details";
//   // static const languageText = "Language";
//   // static const logoutText = "Logout";
//   // static const englishText = "English";
//   // static const croatianText = "Croatian";
//
//   /// Create Invoice Screen
//   // static const selectClientText = "Select Client";
//   // static const createInvoiceText = "Create Invoice";
//   // static const selectDueDateText = "Select Due Date";
//   // static const selectCurrencyText = "Select Currency";
//   // static const quantityText = "Quantity";
//   // static const rateText = "Rate";
//   // static const amountText = "Amount";
//   // static const addNewItemText = "+ Add New Item";
//
//   ///Edit Invoice
//   // static const editInvoiceText = "Edit invoice";
//   // static const diAbleClientText = "Disable Client";
//   // static const areYouSureText = "Are you sure you want to disable client?";
//   // //static const deleteText = "Delete Invoice";
//   // //static const areYouSureDeleteText = "Are you sure you want to delete Invoice";
//   // static const forgotPasswordText = "Forgot Password";
//   // static const enterYourEmailForResetPassText = "Enter your email for reset password";
//   // static const editClientText = "Edit Client";
// }

class AppStringLocal {
  static const Map<String, dynamic> en = {
    /// Invoice Screen

    "Invoice": "Invoice",
    "SignIn": "SignIn",
    "SignUp": "SignUp",
    "Lets": "Let's get started by filling out the form below.",
    "ForgotPassword": "Forgot Password",
    "ContinueWithGoogle": "Continue with google",
    "CreateAccount": "Create Account",
    "Name": "Name",
    "Password": "Password",
    "ConfirmPassword": "ConfirmPassword",

    ///Home Screen

    "Paid": "Paid",
    "Unpaid": "Unpaid",
    "All": "All",
    "Invoices": "Invoices",
    "Amount": "Amount",
    "DueBy": "Due by",

    ///Client Screen

    "Client": "Clients",
    "AddNewClient": "Add new client",
    "FullName": "Full Name",
    "Email": "Email",
    "PhoneNumber": "Phone Number",
    "Address": "Address",
    "City": "City",
    "Country": "Country",
    "Description": "Description",
    "Save": "Save",
    "PleaseEnterName": "Please Enter name",
    "PleaseEnterEmail": "Please Enter email",
    "PleaseEnterPhoneNumber": "Please Enter Phone number",
    "PleaseEnterAddress": "Please Enter address",
    "PleaseEnterCity": "Please Enter city",
    "SelectCountry": "Select Country",
    "PleaseEnterDescription": "Please Enter Description",
    "RecentInvoice": "Recent Invoice",
    "PleaseAddYourBankDetails": "Please add your bank details",
    "PaymentDetails": "Payment Details",

    "FirstName": "First Name",
    "LastName": "Last Name",
    "IBAN": "IBAN",
    "BIC": "BIC",
    "CompanyName": "Company Name",
    "plEnFirstNameText": "Please Enter First Name",
    "plEnLastNameText": "Please Enter Last Name",
    "plEnIBANText": "Please Enter IBAN",
    "plEnBICText": "Please Enter BIC",
    "plEnCompanyName": "Please Enter Company Name",

    "AccountHoldText": "Account Holder's Name",
    "AccountNumber": "Account Number",
    "plEnAcNumText": "Please enter account number",
    "BankName": "Bank Name",
    "plEnBankNameText": "Please enter bank name",
    "BankAddress": "Bank Address",
    "plEnBankAddressText": "Please enter bank address",
    "ifscText": "IFSC Code",
    "plEnIfscCodeText": "Please enter IFSC code",
    "PANNumber": "PAN Number",
    "plEnPanNumText": "Please enter PAN number",

    ///ProfileScreen

    "Profile": "Profile",
    "EditUser": "Edit User",
    "Account": "Account",
    // "PaymentDetails":"Payment Details",
    "Language": "Language",
    "Logout": "Logout",
    "English": "English",
    "Croatian": "Croatian",

    /// Create Invoice Screen

    "SelectClient": "Select Client",
    "CreateInvoice": "Create Invoice",
    "SelectDueDate": "Select Due Date",
    "SelectCurrency": "Select Currency",
    "Quantity": "Quantity",
    "Rate": "Rate",
    // "Amount":"Amount",
    "AddNewItem": "+ Add New Item",
    "EnterVAT": "Enter VAT",
    "CommentHere": "Comment here...",

    ///Edit Invoice

    "EditInvoice": "Edit invoice",
    "DisableClient": "Disable Client",
    "areYouSureText": "Are you sure you want to disable client?",
    "DeleteInvoice": "Delete Invoice",
    "areYouSureDeleteText": "Are you sure you want to delete Invoice",
    //"ForgotPassword":"Forgot Password",
    "enterYourEmailForResetPassText": "Enter your email for reset password",
    "EditClient": "Edit Client",

    ///DATE PICKER
    "Cancel": "Cancel",
    "Ok": "Ok",
    "SelectDate": "Select Date",
  };
  static const Map<String, dynamic> hr = {
    /// Invoice Screen

    "Invoice": "Dostavnica",
    "SignIn": "Prijaviti se",
    "SignUp": "Prijavite se",
    "Lets": "Započnimo ispunjavanjem obrasca u nastavku.",
    "ForgotPassword": "Zaboravili ste lozinku",
    "ContinueWithGoogle": "Nastavite s googleom",
    "CreateAccount": "Napravi račun",
    "Name": "Ime",
    "Password": "Lozinka",
    "ConfirmPassword": "Potvrdi lozinku",

    ///Home Screen

    "Paid": "Plaćeno",
    "Unpaid": "Neplaćeno",
    "All": "svi",
    "Invoices": "Fakturel",
    "Amount": "Iznos",
    "DueBy": "Rok do",

    ///Client Screen

    "Client": "Klijenti",
    "AddNewClient": "Dodaj novog klijenta",
    "FullName": "Puno ime",
    "Email": "E-mail",
    "PhoneNumber": "Broj telefona",
    "Address": "Adresa",
    "City": "Grad",
    "Country": "Zemlja",
    "Description": "Opis",
    "Save": "Uštedjeti",
    "PleaseEnterName": "Unesite ime",
    "PleaseEnterEmail": "Molimo unesite email",
    "PleaseEnterPhoneNumber": "Molimo unesite telefonski broj",
    "PleaseEnterAddress": "Unesite adresu",
    "PleaseEnterCity": "Unesite grad",
    "SelectCountry": "Odaberi državu",
    "PleaseEnterDescription": "Unesite opis",
    "RecentInvoice": "Najnovija faktura",
    "PleaseAddYourBankDetails": "Dodajte svoje bankovne podatke",
    "PaymentDetails": "Pojedinosti o plaćanju",

    "FirstName": "Ime",
    "LastName": "Prezime",
    "IBAN": "IBAN",
    "BIC": "BIC",
    "CompanyName": "Naziv tvrtke",
    "plEnFirstNameText": "Unesite ime",
    "plEnLastNameText": "Unesite prezime",
    "plEnIBANText": "Unesite IBAN",
    "plEnBICText": "Unesite BIC",
    "plEnCompanyName": "Unesite naziv tvrtke",

    "AccountHoldText": "Ime vlasnika računa",
    "AccountNumber": "Broj računa",
    "plEnAcNumText": "Unesite broj računa",
    "BankName": "Ime banke",
    "plEnBankNameText": "Unesite naziv banke",
    "BankAddress": "Adresa banke",
    "plEnBankAddressText": "Unesite adresu banke",
    "ifscText": "IFSC kod",
    "plEnIfscCodeText": "Unesite IFSC kod",
    "PANNumber": "PAN broj",
    "plEnPanNumText": "Unesite PAN broj",

    ///ProfileScreen

    "Profile": "Profil",
    "EditUser": "Uredi korisnika",
    "Account": "Račun",
    // "PaymentDetails":"Payment Details",
    "Language": "Jezik",
    "Logout": "Odjavite se",
    "English": "Engleski",
    "Croatian": "Hrvatski",

    /// Create Invoice Screen

    "SelectClient": "Odaberite Klijent",
    "CreateInvoice": "Izradi fakturu",
    "SelectDueDate": "Odaberite Rok",
    "SelectCurrency": "Odaberite Valutu",
    "Quantity": "Količina",
    "Rate": "Stopa",
    // "Amount":"Amount",
    "AddNewItem": "+ Dodaj novu stavku",
    "EnterVAT": "Unesite PDV",
    "CommentHere": "Komentirajte ovdje..",

    ///Edit Invoice

    "EditInvoice": "Uredi fakturu",
    "DisableClient": "Onemogući klijenta",
    "areYouSureText": "Jeste li sigurni da želite onemogućiti klijenta?",
    "DeleteInvoice": "Izbriši fakturu",
    "areYouSureDeleteText": "Jeste li sigurni da želite izbrisati fakturu",
    //"ForgotPassword":"Forgot Password",
    "enterYourEmailForResetPassText":
        "Unesite svoju e-poštu za resetiranje lozinke",
    "EditClient": "Uredi klijenta",

    ///DATE PICKER
    "Cancel": "ODUSTANI",
    "Ok": "U REDU",
    "SelectDate": "ODABERI DATUM",
  };
}

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': AppStringLocal.en.cast<String, String>(),
        'hr_HR': AppStringLocal.hr.cast<String, String>(),
      };
}
