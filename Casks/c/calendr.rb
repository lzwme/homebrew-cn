cask "calendr" do
  version "1.20.6"
  sha256 "27ac070ea245966656fc2d170ff6d6641723849cf460c4045aac3b44f081562e"

  url "https://ghfast.top/https://github.com/pakerwreah/Calendr/releases/download/v#{version}/Calendr.zip"
  name "Calendr"
  desc "Menu bar calendar"
  homepage "https://github.com/pakerwreah/Calendr"

  depends_on macos: ">= :sonoma"

  app "Calendr.app"

  zap trash: [
    "~/Library/Application Scripts/br.paker.Calendr",
    "~/Library/Containers/br.paker.Calendr",
  ]
end