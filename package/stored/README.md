# Stored

Stored is a Dart library for loading data from remote and local sources.

## The Problems:

+ Modern software needs data representations to be fluid and always available.
+ Users expect their UI experience to never be compromised (blocked) by new data loads. Whether an application is social, news or business-to-business, users expect a seamless experience both online and offline.
+ International users expect minimal data downloads as many megabytes of downloaded data can quickly result in astronomical phone bills.

A Store is a class that simplifies fetching, sharing, storage, and retrieval of data in your application. A Store is similar to the [Repository pattern](https://msdn.microsoft.com/en-us/library/ff649690.aspx) while exposing an API built with [dart:async](https://api.flutter.dev/flutter/dart-async/dart-async-library.html) that adheres to a unidirectional data flow.

Store provides a level of abstraction between UI elements and data operations.


### Overview

A Store is responsible for managing a particular data request. When you create an implementation of a Store, you provide it with a `Fetcher`, a function that defines how data will be fetched over network. You can also define how your Store will cache data in-memory and on-disk. Since Store returns your data as a `Flow`, threading is a breeze! Once a Store is built, it handles the logic around data flow, allowing your views to use the best data source and ensuring that the newest data is always available for later offline use.

Store leverages multiple request throttling to prevent excessive calls to the network and disk cache. By utilizing Store, you eliminate the possibility of flooding your network with the same request while adding two layers of caching (memory and disk) as well as ability to add disk as a source of truth where you can modify the disk directly without going through Store (works best with databases that can provide observables sources like [hive](https://pub.dev/packages/hive), [sqflite](https://pub.dev/packages/sqflite) or [Realm](https://github.com/realm/realm-dart))

