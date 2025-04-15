class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacomputer"
  url "https:github.comtrycuacomputerarchiverefstagslume-v0.1.34.tar.gz"
  sha256 "43784fd24cce5282534247b78af1fc63a98fbfd4fca2db91b618ef65003ab40c"
  license "MIT"
  head "https:github.comtrycuacomputer.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606f0bb3e2a086777c5b5d5af60b5a21f5a8cc4caaa39a3658af70a86bb9f199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c45cae357bb8ee66fc57864d2b2f184d5d19991961c116f3de0d2cec0e5d6c"
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