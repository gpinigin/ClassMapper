//
//  ClassMapperTests.m
//  ClassMapperTests
//
//  Created by Gleb on 3/10/13.
//
//

#import "ClassMapperTests.h"
#import "ClassMapping.h"

@interface Article : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@end


@implementation Article
@end

@implementation ClassMapperTests

- (void)testAttributeMapping {
    NSData *data = [@"{\"article\":{\"name\":\"A Falen Hero\",\"author\":\"Goeu Arhtur\"}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];    

    ClassMapping *articleMapping = [ClassMapping mappingWithClass:[Article class]];
    [articleMapping addAttributeMappingFromKeyPath:@"article.name" toObjectPath:@"title"];
    [articleMapping addAttributeMappingFromKeyPath:@"article.author" toObjectPath:@"author"];
    
    NSArray *array = [articleMapping objects:dict];
    
    STAssertTrue(array.count > 0, @"Array is empty");
    Article *article = [array objectAtIndex: 0];    
    
    STAssertEqualObjects(@"A Falen Hero", article.title, @"Title doesn't match");
    STAssertEqualObjects(@"Goeu Arhtur", article.author, @"Author doesn't match");
}



@end
