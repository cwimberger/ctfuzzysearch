Pod::Spec.new do |s|
  s.name           = 'CTFuzzySearch'
  s.version        = '1.0.1'
  s.summary        = "CTFuzzySearch is a lightweight framework for fast and fuzzy string searching."
  s.homepage       = "https://github.com/cwimberger/ctfuzzysearch"
  s.author         = { 'Christoph Wimberger' => 'christoph@wimberger.org' }
  s.source         = { :git => 'https://github.com/cwimberger/ctfuzzysearch.git', :tag => s.version.to_s }
  s.platform       = :ios
  s.requires_arc   = true
  s.source_files   = 'source/*'
  s.license        = 'MIT'
end