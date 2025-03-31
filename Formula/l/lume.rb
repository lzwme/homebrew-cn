class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacomputer"
  url "https:github.comtrycuacomputerarchiverefstagslume-v0.1.21.tar.gz"
  sha256 "8392bc18baef58684514f31abbd56dc3265faa6143c6ceef133a6bcdad535ed1"
  license "MIT"
  head "https:github.comtrycuacomputer.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2a41e2a564cbd320dd655043c765300a068cdb537d9c34107025cb676e22b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65bbfdf8a14901fbcdc16d5dd7eb1ba5a5a8d22da9a2a6969419f430321499c"
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