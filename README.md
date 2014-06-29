CTFuzzySearch is a lightweight framework for fast and fuzzy string searching.
=============================================================================

This repository contains the CTFuzzySearch engine and example usage.

Code Sample
-----------
This minimalistic code sample should get you started within a few minutes. For a bigger demo have a look into the example implementation.
```Objective-C
CTFuzzyIndex *index = [CTFuzzyIndex new];

// Add words to the index, these can be hundreds of thousands
[index addWordsFromString:@"fuzzy string searching using CTFuzzySearch" options:CTFuzzyIndexIncludeRanges];
    
// Search the index for matches of word with 2 errors maximum
NSArray *matches = [index search:@"zearchin" withMaxDistance:2];
for(CTFuzzyMatch *match in matches) {
    NSLog("Found %d occurrences of matching word '%@'.", [match.data count], match.value);
}
```
