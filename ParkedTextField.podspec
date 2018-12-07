Pod::Spec.new do |s|
  s.name             = "ParkedTextField"
  s.version          = "0.5.0"
  s.summary          = "A UITextField subclass with an appended constant text"
  s.homepage         = "https://github.com/gmertk/ParkedTextField"
  s.screenshots      = "https://dl.dropboxusercontent.com/u/4397140/pod-screenshots/ParkedTextField.gif"
  s.license          = 'MIT'
  s.author           = { "Gunay Mert Karadogan" => "mertkaradogan@gmail.com" }
  s.source           = { :git => "https://github.com/gmertk/ParkedTextField.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gunaymertk'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'ParkedTextField/ParkedTextField/*.swift'
end
