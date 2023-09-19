String convertTime(String minutes) {
  if (minutes.length == 1) {
    return "0$minutes";
  } else {
    return minutes;
  }
}
//  the convertTime function takes a string representing minutes as input. If the input represents a single-digit number of minutes (e.g., "5"), the function adds a leading zero to make it a two-digit format (e.g., "05"). If the input is already a two-digit number (e.g., "10"), the function returns the input string as is. This function can be useful when formatting time-related data for display in your Flutter app.