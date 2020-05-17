import 'package:intl/intl.dart';

class Constants {
  static final dateFormat = DateFormat('yyyyMMdd', "en_US");

  static const String USER_AGENT = "Mozilla/5.0";

  //{0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  static const String GOOGLE_TREND_CATEGORY_URL =
      "https://trends.google.com.vn/trends/api/explore/pickers/category?hl={0}&tz=-420";

  //{0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  static const String GOOGLE_TREND_GEOGRAPHY_URL =
      "https://trends.google.com.vn/trends/api/explore/pickers/geo?hl={0}&tz=-420";

  // This url contains data of each stories but not detail
  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {1}: ID of story. You can add more than one ID and each is separated by "," (id=xx...,id=yyf...)
  static const String TRENDING_SUMMARY_URL =
      "https://trends.google.com.vn/trends/api/stories/summary?hl=%s&tz=-420&cat=%s&geo=VN&%s";


  // This url contains data of each stories but not detail
  // {0}: ID of story you want to get
  // {1}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  static const String RELATED_ARTICLE_URL =
      "https://trends.google.com.vn/trends/api/stories/%s?hl=%s&tz=-420";


  // This url contains point (level of popular) in 24 hours of each stories
  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {1}: ID of story. You can add more than one ID and each is separated by "," (id=9,id=8)
  static const String TRENDING_SPARK_LINE_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/sparkline?hl={0}&tz=-420&{1}";

  // This url contains detail stories
  // {0}: ID of story. You can add more than one ID and each is separated by "," (id=9,id=8)
  // {1}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  static const String TRENDING_STORY_URL =
      "https://trends.google.com.vn/trends/api/stories/{0}?hl={1}&tz=-420&sw=10";

  // This url contains query related with our story or keyword( when you use explore to search)
  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {1}: TIME (we will get these parameters in data get from TRENDING_STORY_URL )
  //       (we will get these parameters in data get from TRENDING_STORY_URL)
  static const String TRENDING_RELATED_QUERY_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/relatedqueries?token={0}&hl={1}&tz=-420";

  // This url contains topic related with our story or keyword( when you use explore to search)
  //  {0}: GEOGRAPHY (The format of list of geography  is in GOOGLE_TREND_GEOGRAPHY_URL response)
  //  {1} {2} {3} {4} {5}: TIME (we will get these parameters in data get from TRENDING_STORY_URL )
  //Each parameters is separated by "\\"
  //2018-04-11T12\\:00\\:00 2018-04-18T09\\:25\\:00
  //When we pass parameter {3} we must replace "+" by space
  //2018-04-11T12\\:00\\:00+2018-04-18T09\\:25\\:00
  //  {6} {7} {8}: mid (we will get these parameters in data get from TRENDING_STORY_URL)
  //  {9}: token this parameter will change each time we visit TRENDING_STORY_URL
  //       (we will get these parameters in data get from TRENDING_STORY_URL)
  static const String TRENDING_RELATED_TOPIC_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/relatedtopics?" +
          "hl=en-US&tz=-420&req=%7B%22geo%22:%7B%22country%22:%22{0}%22%7D," +
          "%22time%22:%{1}%5C%5C:{2}%5C%5C:{3}%5C%5C:{4}%5C%5C:{5}%22," +
          "%22mid%22:%5B%22%2Fm%2F{6}%22,%22%2Fm%2F{7}%22,%22%2Fg%2F{8}%22%5D," +
          "%22locale%22:%22{9}%22%7D&token={9}";

  // This url contains data that is related with our story or keyword( when you use explore to search)
  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {1} : CATEGORY  (The format of list of geography  is in GOOGLE_TREND_CATEGORY_URL response)
  // {2}: GEOGRAPHY (The format of list of geography  is in GOOGLE_TREND_GEOGRAPHY_URL response)
  static const String GOOGLE_TREND_URL =
      "https://trends.google.com.vn/trends/api/realtimetrends?hl=%s&tz=-420&cat=%s&fi=0&fs=0&geo=%s&ri=300&rs=15&sort=0";

  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {1}: keyword (you search in explore,each word combines with "+" hotnews: chau+van+sang )
  // {2}: GEOGRAPHY (The format of list of geography  is in GOOGLE_TREND_GEOGRAPHY_URL response)
  // {3}:  time A string specifying the time span of the query. Possible values are:
  // \describe{ \item{"now 1-H"}{Last hour} \item{"now 4-H"}{Last four hours}
  //  \item{"now 1-d"}{Last day} \item{"now 7-d"}{Last seven days} \item{"today
  //   1-m"}{Past 30 days} \item{"today 3-m"}{Past 90 days} \item{"today
  //   12-m"}{Past 12 months} \item{"today+5-y"}{Last five years (default)}
  //  \item{"all"}{Since the beginning of Google Trends (2004)} \item{"Y-m-d
  //  Y-m-d"}{Time span between two dates (ex.: "2010-01-01 2010-04-03")} }
  //  time <- "today+5-y"
  //  time <- "2017-02-09 2017-02-18"
  //  time <- "now 7-d"
  //  time <- "all_2006"
  //  time <- "all"
  //  time <- "now 4-H"
  // {4}:   CATEGORY  (The format of list of geography  is in GOOGLE_TREND_CATEGORY_URL response)
  // {5}:  A character string defining the Google product for which the trend query if preformed. Valid options are:
  //  \itemize{ \item "web" or "" (default) \item "news" \item "images" \item "froogle"
  //  \item "youtube" }
  static const String EXPLORE_TREND_URL =
      "https://trends.google.com.vn/trends/api/explore?" +
          "hl={0}&tz=-420&req=%7B%22comparisonItem%22:%5B%7B%22keyword%22:%22{1}%22," +
          "%22geo%22:%22{2}%22,%22time%22:%22{3}%22%7D%5D,%22category%22:0,%22property%22:%22%22%7D&tz=-420";

  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {2}: GEOGRAPHY (The format of list of geography  is in GOOGLE_TREND_GEOGRAPHY_URL response)
  // {3}:  time A string specifying the time span of the query. Possible values are:
  // \describe{ \item{"now 1-H"}{Last hour} \item{"now 4-H"}{Last four hours}
  //  \item{"now 1-d"}{Last day} \item{"now 7-d"}{Last seven days} \item{"today
  //   1-m"}{Past 30 days} \item{"today 3-m"}{Past 90 days} \item{"today
  //   12-m"}{Past 12 months} \item{"today+5-y"}{Last five years (default)}
  //  \item{"all"}{Since the beginning of Google Trends (2004)} \item{"Y-m-d
  //  Y-m-d"}{Time span between two dates (ex.: "2010-01-01 2010-04-03")} }
  //  time <- "today+5-y"
  //  time <- "2017-02-09 2017-02-18"
  //  time <- "now 7-d"
  //  time <- "all_2006"
  //  time <- "all"
  //  time <- "now 4-H"
  static const String RELATED_SEARCH =
      "https://trends.google.com.vn/trends/api/widgetdata/relatedsearches?" +
          "hl={0}&tz=-420&req=%7B%22restriction%22:%7B%22geo%22:%7B%22country%22:%22{1}%22%7D,%22time" +
          "%22:%22{2018-03-20+2018-04-20}%22,%22originalTimeRangeForExploreUrl%22" +
          ":%22{today+1-m}%22,%22complexKeywordsRestriction%22:%7B%22keyword%22" +
          ":%5B%7B%22type%22:%22{PHRASE}%22,%22value%22:%22{xs+quang+tri}%22%7D%5D%7D%7D" +
          ",%22keywordType%22:%22{ENTITY}%22,%22metric%22:%5B%22{TOP}%22,%22{RISING}%22%5D," +
          "%22trendinessSettings%22:%7B%22compareTime%22:%22{2018-02-16+2018-03-19}%22%7D" +
          ",%22requestOptions%22:%7B%22property%22:%22%22,%22backend%22:%22{IZG}%22,%22" +
          "category%22:{0}%7D,%22language%22:%22{en}%22%7D&token={}";
  static const String TIMELINE_TOPIC_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/timeline?" +
          "hl={0}&tz=-420&req=%7B%22geo%22:%7B%22country%" +
          "22:%22{1}%22%7D,%22time%22:%22{2}%5C%5C{3}%5C%5C{4}%5C%5C" +
          "{5}%5C%5C{6}%22,%22resolution%22:%22REGION%22,%22mid%22:%5B{7}%5D,%22locale%22:%22{8}%22," +
          "%22skipPrivacyChecksForGeos%22:true%7D&token={9}&tz=-420";

  static const String TRENDING_QUERY =
      "https://trends.google.com/trends/api/widgetdata/relatedqueries?" +
          "token={0}&hl={1}&tz=-420";

  static const String TRENDING_GEOMAPS =
      "https://trends.google.com/trends/api/widgetdata/geomap?" +
          "hl={0}&tz=-420&req=%7B%22geo%22:%7B%22country%" +
          "22:%22{1}%22%7D,%22time%22:%22{2}%5C%5C{3}%5C%5C{4}%5C%5C" +
          "{5}%5C%5C{6}%22,%22resolution%22:%22REGION%22,%22mid%22:%5B{7}%5D,%22locale%22:%22{8}%22," +
          "%22skipPrivacyChecksForGeos%22:true%7D&token={9}";

  //{0} : 2Fm or 2Fg
  static const String GEOMAPS_SAPARATION = "%22%{0}%2F{1}%22";

  static const String NEWS_URL =
      "https://news.google.com/news/rss/search/section/q/{0}/{0}?hl=vi&gl=VN&ned=vi_vn";

  //en-US
  //geo :VN
  static const String TIME_LINE_EXPLORE_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/multiline?hl={0}&tz=-420&req=%7B%22" +
          "time%22:%22{1}%22,%22resolution%22:%22{2}%22,%22locale%22:%22{3}%22," +
          "%22comparisonItem%22:%5B%7B%22geo%22:%7B%22country%22:%22{4}%22%7D,%22complexKeywordsRestriction%22:" +
          "%7B%22keyword%22:%5B%7B%22type%22:%22{5}%22,%22value%22:%22{6}%22%7D%5D%7D%7D%5D,%22" +
          "requestOptions%22:%7B%22property%22:%22%22,%22backend%22:%22{7}%22,%22" +
          "category%22:0%7D%7D&token={8}&tz=-420";

  //https://www.google.com.vn/search?hl=vi-VN&tbm=nws&q=google
  static const String GEOMAPS_EXPLORE_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/comparedgeo?" +
          "hl={0}&tz=-420&req=%7B%22geo%22:%7B%22country%22:%22{1}%22%7D,%22" +
          "comparisonItem%22:%5B%7B%22time%22:%22{2}%22,%22" +
          "complexKeywordsRestriction%22:%7B%22keyword%22:%5B%7B%22type%22:%22{3}%22," +
          "%22value%22:%22{4}%22%7D%5D%7D%7D%5D,%22resolution%22:%22{5}%22,%22" +
          "locale%22:%22{6}%22,%22requestOptions%22:%7B%22property%22:%22%22,%22backend%22:%22{7}%22," +
          "%22category%22:0%7D%7D&token={8}";
  static const String RELATED_QUERY_EXPLORE_URL =
      "https://trends.google.com.vn/trends/api/widgetdata/relatedsearches?" +
          "hl={0}&tz=-420&req=%7B%22restriction%22:%7B%22geo%22:%7B%22country%22:%22{1}%22%7D," +
          "%22time%22:%22{2}%22,%22originalTimeRangeForExploreUrl%22:%22{3}%22," +
          "%22complexKeywordsRestriction%22:%7B%22keyword%22:%5B%7B%22type%22:%22{4}%22," +
          "%22value%22:%22{5}%22%7D%5D%7D%7D,%22keywordType%22:%22{6}%22,%22metric%22:%5B%22{7}%22," +
          "%22{8}%22%5D,%22trendinessSettings%22:%7B%22compareTime%22:%22{9}%22%7D," +
          "%22requestOptions%22:%7B%22property%22:%22%22,%22backend%22:%22{10}%22,%22category%22:0%7D," +
          "%22language%22:%22{11}%22%7D&token={12}";
  static const String TENDENCY_URL =
      "https://trends.google.com.vn/trends/hottrends/hotItems";
  // {0}: LANGUAGE (you can get list format of language to google_trend_language.txt in root of project)
  // {1}: DATE (format date yyyyMMdd): date you want to get trend search
  // {2}: GEOGRAPHY (The format of list of geography  is in GOOGLE_TREND_GEOGRAPHY_URL response)

  static const String DAILY_TREND_SEARCH_URL =
      "https://trends.google.com.vn/trends/api/dailytrends?hl=%s&tz=-420&ed=%s&geo=%s&ns=15";
}
