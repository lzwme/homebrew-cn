cask "vbrokers" do
  version "2.5.934,600001,1745824139"
  sha256 "24ba95b039de2914a1dc722968072a240c859ffdb5231c6b49609f8a32c55f8b"

  url "https://r.hstong.com/public/app/Mac/HSTONG_Mac_#{version.csv.second}_#{version.csv.first}_#{version.csv.third}.dmg"
  name "VBrokers"
  desc "Trading platform"
  homepage "https://www.hstong.com/"

  livecheck do
    url "https://www.hstong.com/download"
    regex(%r{href=['"].*?/HSTONG[-_]?Mac[-_]?(\d+)[-_]?(\d+(?:\.\d+)+)[-_]?(\d+)\.dmg}i)
    strategy :page_match do |page, regex|
      page.scan(regex)
          .map { |match| "#{match[1]},#{match[0]},#{match[2]}" }
    end
  end

  # Rename to match displayed name
  app "HSTong.app", target: "VBrokers.app"

  zap trash: [
    "~/Library/Application Scripts/com.hszq.HSSecuritiesForMac",
    "~/Library/Containers/com.hszq.HSSecuritiesForMac",
  ]
end