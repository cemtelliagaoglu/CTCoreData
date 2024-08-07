# CTCoreData
CTCoreData is a Swift package that provides a convenient and efficient way to work with Core Data in your projects.

## Features
- Simplified Core Data stack setup
- Easy-to-use CRUD operations
- Asynchronous operations support
- Completion Handler and async/await support
- Read objects by Filtering with NSPredicate
- Read objects by Sorting with NSSortDescriptor

## Installation
You can integrate CTCoreData into your project using Swift Package Manager.

### Swift Package Manager
Add the following dependency to your Package.swift file:

``` swift
dependencies: [
    .package(url: "https://github.com/cemtelliagaoglu/CTCoreData.git", .upToNextMajor(from: "1.0.1"))
]
```

### [Basic Usage](docs/basic-usage.md)
- [Sample Project with Completion Handler](SampleProjects/SampleProject)
- [Sample Project with async await](SampleProjects/SampleProjectAsyncAwait)

## Contributions
Contributions are always welcome!
