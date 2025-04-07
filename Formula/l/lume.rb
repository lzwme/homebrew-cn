class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacomputer"
  url "https:github.comtrycuacomputerarchiverefstagslume-v0.1.26.tar.gz"
  sha256 "80599c3629022e4fe46a4c5a54851272b68c37bfc0a5b028706f75984066e32b"
  license "MIT"
  head "https:github.comtrycuacomputer.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed1026d50504a4c4d3c949fc3048d686295e19cbb39115652574aa69943de95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5142059815532495ba72bfd0dfc0015f664aae60c12bde8f4ceecf946e0d65b8"
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