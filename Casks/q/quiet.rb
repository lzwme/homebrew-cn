cask "quiet" do
  version "2.3.2"
  sha256 "a7f1b89d9521f285ac2409c42046741c3931dfd1293747386fb72d4fe0ea53b6"

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