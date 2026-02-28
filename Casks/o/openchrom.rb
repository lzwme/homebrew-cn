cask "openchrom" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.6.7"
  sha256 arm:   "23e72c95cde9a234cdc0efe7801c81f91e6cbc88461cc33ea281da02a217fb15",
         intel: "40b62d1282bbe561a42305d67c584e86ea1a2de4f8970bb643a7433f99207c72"

  url "https://products.lablicate.com/openchrom/#{version}/OpenChrom_#{version}_#{arch}.dmg",
      verified: "products.lablicate.com/openchrom/"
  name "OpenChrom"
  desc "Data analysis for analytical chemistry"
  homepage "https://www.openchrom.net/"

  livecheck do
    url "https://marketplace.lablicate.com/api/downloads/hash-size"
    regex(/OpenChrom[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmg/i)
    strategy :json do |json, regex|
      json.dig("data", "items")&.filter_map do |item|
        item["name"]&.[](regex, 1)
      end
    end
  end

  no_autobump! because: :bumped_by_upstream

  depends_on macos: ">= :big_sur"

  app "OpenChrom.app"

  zap trash: [
    "~/.openchrom",
    "~/OpenChrom",
  ]
end