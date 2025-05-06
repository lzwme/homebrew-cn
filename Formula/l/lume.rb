class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacomputer"
  url "https:github.comtrycuacomputerarchiverefstagslume-v0.2.9.tar.gz"
  sha256 "a68eece8f42ef1f5fc6feab36158512e8d997b95a4fb0c97f6872acecbe96c59"
  license "MIT"
  head "https:github.comtrycuacomputer.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7681052ca67feb6965f903af7983b37c556e342b14893e5fce373993c07bd589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167193fb9e88e6cc5021bbde6d8ff3dfb44ee053b14b7d1007b8fe1744df1b6e"
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