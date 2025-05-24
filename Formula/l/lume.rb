class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacua"
  url "https:github.comtrycuacuaarchiverefstagslume-v0.2.15.tar.gz"
  sha256 "13e33eeaa7cc459975a2045cc7c81128ea030988f8c493d2e903967fefd98d8c"
  license "MIT"
  head "https:github.comtrycuacua.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24daf74bc4a40c20664689c07289628f95e28b6f809d291ebf9d064a7d140abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20eb306a5ac5f378fa4a2c3686941ef3ca418105be222e653e0ea28fc0d25330"
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