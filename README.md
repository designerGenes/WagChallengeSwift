# WagChallengeSwift
The Wag coding challenge, in Swift

This project retrieves the first page of data from the Stackoverflow Users API, converts the JSON response into tableView cells, and awards badges for conditions such as length of account lifetime and above-average or rapidly changing reputation.  Several components respond to touch events by changing their containing cell to display more detailed information.     

This project uses two 3rd party libraries: Alamofire to wrap networking requests and cache downloaded images, and SwiftyJSON to convert HTTP responses into useable JSON.  These could be replaced with NSURLRequests and native JSON methods but the libraries used are lightweight and reliable.
