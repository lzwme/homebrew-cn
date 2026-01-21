class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/cua"
  url "https://ghfast.top/https://github.com/trycua/cua/archive/refs/tags/lume-v0.2.46.tar.gz"
  sha256 "b13ad7bd15baa8ab4d7eb42440a2282dc2cf95cd5d9535fc50192b4c41f2ac8b"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adc9d32242c88b4dd18c7a337df3d1d53ab020862612aaf690eecff3339783e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e88dac8141708814d1ed001ae4ecc1b9ff229404729001a7d5608530c2f7803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155c126fd1329574a075611970a1d3f4d7e73603133ec31efe69f83321c84e52"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  service do
    run [opt_bin/"lume", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/lume.log"
    error_log_path var/"log/lume.log"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    port = free_port
    pid = spawn bin/"lume", "serve", "--port", port.to_s
    sleep 5
    begin
      # Serves 404 Not found if no machines created
      assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end