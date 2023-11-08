cask "postmancanary" do
  arch arm: "osx_arm64", intel: "osx64"

  version "10.19.15-canary231101-0730"
  sha256 arm:   "0bedde1defbb1cda9473dbe33229cdafc5a969d00ea6d588dc0ce433627062ff",
         intel: "45753dc375bd969e68312947a07a7869f0dca2188af89e27987e73cb6f3ac594"

  url "https://dl.pstmn.io/download/version/#{version}/#{arch}",
      verified: "dl.pstmn.io/download/version/"
  name "Postman Canary"
  desc "Collaboration platform for API development"
  homepage "https://www.postman.com/"

  # This is a workaround to a slow-to-update livecheck. It uses the in-app
  # update check link and queries the available versions for a generic major
  # version. We cannot use #{version} as the URL does not exist if #{version}
  # is the latest version available.
  livecheck do
    url "https://dl.pstmn.io/update/status?currentVersion=#{version.major}.0.0&platform=osx_arm64&channel=canary"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true

  app "PostmanCanary.app"

  zap trash: "~/Library/Application Support/PostmanCanary"
end