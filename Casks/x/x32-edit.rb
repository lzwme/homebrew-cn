cask "x32-edit" do
  version "4.4.1,YSCXK_yETESoGXDjR7eEMA,8XnUpbE1hEqmH3z3FzdNAw"
  sha256 "65ad5512474beb5c54da421185d9a7e9479c95237fd6ca6c6f914c30b3dcd5ef"

  url "https://cdn.mediavalet.com/aunsw/musictribe/#{version.csv.second}/#{version.csv.third}/Original/X32-Edit_MAC_#{version.csv.first}.zip",
      verified: "mediavalet.com/aunsw/musictribe/"
  name "X32 Edit"
  desc "Remote control for Behringer X32 audio consoles"
  homepage "https://www.behringer.com/product.html?modelCode=0603-ACE"

  livecheck do
    url "https://www.behringer.com/.rest/musictribe/v1/products/media-library?brandName=behringer&modelCode=0603-ACE"
    regex(%r{([^/]+)/([^/]+)/Original/X32[._-]Edit[._-]MAC[._-]v?(\d+(?:\.\d+)+)\.zip}i)
    strategy :json do |json, regex|
      json.filter_map do |category|
        next if category["title"] != "Software"

        category["list"]&.map do |item|
          next unless item["title"]&.match?(/X32 Edit \(MAC\)/i)

          match = item["url"]&.match(regex)
          next if match.blank?

          "#{match[3]},#{match[1]},#{match[2]}"
        end
      end.flatten
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "X32-Edit.app"

  zap trash: "~/Library/.X32-Edit"
end