cask "fme" do
  arch arm: "aarch64", intel: "x64"
  folder = on_arch_conditional arm: "-aarch64"

  version "2023.1.2,23641"
  sha256 arm:   "323795fbd3848d13e71899c8f9a1d3607a05c1d71ede524d27c6c759ed5c8ddb",
         intel: "ac4392fcd2a8156495d7c8c5a9aa5e9e9d48d9ea905a1bf50faf801d0a2df206"

  url "https://downloads.safe.com/fme/#{version.major}/macos#{folder}/fme-form-#{version.csv.first}-b#{version.csv.second}-macosx-#{arch}.pkg"
  name "FME Form"
  desc "Platform for integrating spatial data"
  homepage "https://www.safe.com/"

  livecheck do
    url "https://engage.safe.com/api/downloads/"
    regex(/fme[._-]form[._-]v?(\d+(?:\.\d+)+)[._-]b(\d+)[._-]macosx[._-]#{arch}\.pkg/i)
    strategy :json do |json, regex|
      json["official"]["desktop"]["mac"].select { |item| item["url"]&.match?(regex) }
                                        .map { |item| "#{item["url"][regex, 1]},#{item["url"][regex, 2]}" }
    end
  end

  pkg "fme-form-#{version.csv.first}-b#{version.csv.second}-macosx-#{arch}.pkg"

  uninstall pkgutil: [
              "com.safesoftware.pkg.engine.fme-form-#{version.major_minor}-b#{version.csv.second}-macosx-#{arch}",
              "com.safesoftware.pkg.apps.fme-form-#{version.major_minor}-b#{version.csv.second}-macosx-#{arch}",
            ],
            delete:  [
              "/Applications/FME #{version.major_minor}",
              "/Library/FME/#{version.major_minor}",
            ]

  zap trash: [
    "~/Library/Application Support/FME",
    "~/Library/Application Support/FME Desktop Help",
    "~/Library/Application Support/FME Help",
    "~/Library/Application Support/FME Workbench",
  ]
end