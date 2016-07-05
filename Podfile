PROJECT_NAME = 'WeekPlaner'
TEST_TARGET = 'WeekPlanerEarlGreyTests'
SCHEME_FILE = 'WeekPlanerEarlGreyTests.xcscheme'


target TEST_TARGET do
  
  project PROJECT_NAME
  inherit! :search_paths
  pod 'EarlGrey'

end

post_install do |installer|
  load('configure_earlgrey_pods.rb')
  configure_for_earlgrey(installer, PROJECT_NAME, TEST_TARGET, SCHEME_FILE)
end