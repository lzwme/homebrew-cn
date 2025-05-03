class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacomputer"
  url "https:github.comtrycuacomputerarchiverefstagslume-v0.2.8.tar.gz"
  sha256 "1c3f8743d835ea25fe9a52bf389be35d439c73858e49599265d83075e6760eff"
  license "MIT"
  head "https:github.comtrycuacomputer.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c48ec0207fa2d5f478ba38388f5d91a9a227accca07e90c43b649fc0c92967b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a932134a916b28ad670f5a10a26352299037818b27ba16efd4c95b2ad621fa4d"
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