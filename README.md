ClassMapper
===========

ClassMapper is a helper library that allows to convert Foundation representation directly to objects presentation using keypath.

Here a few example of usage:
    // Suppose we have a jsonObject {"article":{"author":"Goue","title":"A fallen hero""}}
    // And class Article with 2 defined properties:
    //    NSString *author  
    //    NSString *title
    NSDictionary *jsonObject
    
    ClassMapping *mapping = [ClassMapping mappingWithClass:[Article class]];
    [mapping addAttributeMappingFromKeyPath:@"article.author" toObjectPath:@"author"];
    [mapping addAttributeMappingFromKeyPath:@"article.title" toObjectPath:@"title"]
    
    Article *goueArticle = [[mapping objects:jsonObject] objectAtIndex:0];
    
