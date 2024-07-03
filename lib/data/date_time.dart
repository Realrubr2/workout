//returns the current date and time as yyyymmdd
String todaysDate(){
  var dateTimeObj = DateTime.now();

  String year = dateTimeObj.year.toString();

  String month = dateTimeObj.month.toString();
  if(month.length == 1){
    month = '0$month';
}


String day = dateTimeObj.day.toString();
if(day.length == 1){
  day = '0$day';
}

String date = year + month + day;

return date;

}

DateTime createDateFromString(String date){
  int year = int.parse(date.substring(0,4));
  int month = int.parse(date.substring(4,6));
  int day = int.parse(date.substring(6,8));

  return DateTime(year, month, day);
}

// convert date to string
String convertDateToString(DateTime date){
  String year = date.year.toString();

  String month = date.month.toString();
  if(month.length == 1){
    month = '0$month';
  }

  String day = date.day.toString();
  if(day.length == 1){
    day = '0$day';
  }

  return year + month + day;
}