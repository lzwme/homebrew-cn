class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycualume"
  url "https:github.comtrycualumearchiverefstagsv0.1.9.tar.gz"
  sha256 "6be0e43366187b753c4f9645d20e27ffda5b06092ef8db0ac798707932bf5373"
  license "MIT"
  head "https:github.comtrycualume.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4df79bd82fda01c6eadfad7575496c8c888cab6a007e72ae22014547db7e225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c655fdab0f83facb0d66f6280d739eb0de9648d6f54f4dbde541cf15ef7599c"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
    system "usrbincodesign", "-f", "-s", "-", "--entitlement", "resourceslume.entitlements", ".buildreleaselume"
    bin.install ".buildreleaselume"
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