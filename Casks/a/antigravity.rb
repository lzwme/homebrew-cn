cask "antigravity" do
  arch arm: "arm", intel: "x64"
  livecheck_arch = on_arch_conditional arm: "-arm64"

  version "1.19.5,5117559161880576"
  sha256 arm:   "498db9a72a9a1129d2904fe62647e6685e11da6a48f77f0b5e45174fe68d3b99",
         intel: "1d217160ba90a8dc98aa62b5a37bde7fadc321fc6a389d480c664ff78b1252f7"

  url "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/#{version.csv.first}-#{version.csv.second}/darwin-#{arch}/Antigravity.dmg",
      verified: "edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/"
  name "Google Antigravity"
  desc "AI Coding Agent IDE"
  homepage "https://antigravity.google/"

  livecheck do
    url "https://antigravity-auto-updater-974169037036.us-central1.run.app/api/update/darwin#{livecheck_arch}/stable/latest"
    regex(%r{/stable/([^/]+)/}i)
    strategy :json do |json, regex|
      match = json["url"]&.match(regex)
      next if match.blank?

      match[1]&.tr("-", ",").to_s
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Antigravity.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  agy_shimscript = "#{staged_path}/agy.wrapper.sh"
  binary agy_shimscript, target: "agy"

  preflight do
    File.write agy_shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/Antigravity.app/Contents/Resources/app/bin/antigravity' "$@"
    EOS
  end

  zap trash: [
    "~/.antigravity/",
    "~/Library/Application Support/Antigravity",
    "~/Library/Caches/com.google.antigravity",
    "~/Library/HTTPStorages/com.google.antigravity",
    "~/Library/Preferences/com.google.antigravity.plist",
    "~/Library/Saved Application State/com.google.Antigravity.savedState",
  ]
end