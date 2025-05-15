class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacua"
  url "https:github.comtrycuacuaarchiverefstagslume-v0.2.14.tar.gz"
  sha256 "974dd0dc00c1bf387ff174afc3cf767014251755aacf1f793345e8639f7bd290"
  license "MIT"
  head "https:github.comtrycuacua.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9f5647807cc84126eb98db2503cf9ea25efa32375926d2d7a67d6bdbe12eb80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3448eab1082d9bd9f9f721695e00787f98bd620ada6c636f4f626e6251eb3974"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libslume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "usrbincodesign", "-f", "-s", "-",
             "--entitlement", "resourceslume.entitlements",
             ".buildreleaselume"
      bin.install ".buildreleaselume"
    end
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}lume ipsw")

    # Test management HTTP server
    # Serves 404 Not found if no machines created
    port = free_port
    fork { exec bin"lume", "serve", "--port", port.to_s }
    sleep 5
    assert_match %r{^HTTP\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}lume").lines.first
  end
end