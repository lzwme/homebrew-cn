cask "opencat" do
  version "2.59.0,1518"
  sha256 "55fd9dee17d854886ec43d8f175a8541b5016565b37fb7b91eb1a60e7a6d1094"

  url "https://opencat.app/releases/OpenCat-#{version.csv.first}.#{version.csv.second}.dmg"
  name "OpenCat"
  desc "Native AI chat client"
  homepage "https://opencat.app/"

  livecheck do
    url "https://opencat.app/releases/versions.xml"
    strategy :sparkle do |item|
      short_version = (item.short_version.count(".") >= 2) ? item.short_version : "#{item.short_version}.0"
      "#{short_version},#{item.version}"
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "OpenCat.app"

  zap trash: [
    "~/Library/Application Scripts/tech.baye.OpenCat",
    "~/Library/Containers/tech.baye.OpenCat",
    "~/Library/Group Containers/group.tech.baye.openai",
    "~/Library/Saved Application State/tech.baye.OpenCat.savedState",
  ]
end