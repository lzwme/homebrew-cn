cask "iris" do
  version "1.2.2"
  sha256 "ce7dd246b849b1c7af0436e8bc4d3fb0cc51e4563db361b480769ed6788c65ae"

  url "https:raw.githubusercontent.comdanielng01product-buildsmasterirismacosIris-#{version}-OSX.zip",
      verified: "raw.githubusercontent.comdanielng01product-builds"
  name "Iris"
  desc "Blue light filter and eye protection software"
  homepage "https:iristech.coiris"

  livecheck do
    url :homepage
    regex(Iris[._-]?v?(\d+(?:\.\d+)+)[._-]?OSX\.zipi)
  end

  app "Iris.app"

  uninstall launchctl: "co.iristech.Iris",
            quit:      "co.iristech.Iris"

  zap trash: [
    "~LibraryPreferencescom.iristech.Iris.plist",
    "~LibrarySaved Application Stateco.iristech.Iris.savedState",
  ]

  caveats do
    requires_rosetta
  end
end