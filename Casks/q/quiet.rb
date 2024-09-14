cask "quiet" do
  version "2.3.1"
  sha256 "6f87e4bcb8e80258bb11944d025308524f948b5b0b8d6a63092f493646f9251c"

  url "https:github.comTryQuietquietreleasesdownload@quietdesktop@#{version}Quiet-#{version}.dmg",
      verified: "github.comTryQuietquiet"
  name "Quiet"
  desc "Private, p2p alternative to Slack and Discord built on Tor & IPFS"
  homepage "https:tryquiet.org"

  # Upstream creates GitHub releases for both stable and alpha versions for
  # both desktop and mobile versions, so it is necessary to check recent
  # releases to match the latest stable desktop version.
  livecheck do
    url :url
    regex(%r{^@quietdesktop@(\d+(?:\.\d+)+)$}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Quiet.app"

  zap trash: "~LibraryApplication SupportQuiet2"

  caveats do
    requires_rosetta
  end
end