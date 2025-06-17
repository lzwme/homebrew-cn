class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https:github.comtrycuacua"
  url "https:github.comtrycuacuaarchiverefstagslume-v0.2.16.tar.gz"
  sha256 "ec8e97e7bc882b75c1b5583c8b63249260ba56675aa636b86d82d69cedbb11f9"
  license "MIT"
  head "https:github.comtrycuacua.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:lume[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa9208b508b9d09146ff8af9dd774fd44c4cf501268db10681281ee3ddc9fa9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d6226f54c29189e8acfc413431c2cef38ac22085f3e69c414209138dec960c"
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

  service do
    run [opt_bin"lume", "serve"]
    keep_alive true
    working_dir var
    log_path var"loglume.log"
    error_log_path var"loglume.log"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}lume ipsw")

    # Test management HTTP server
    port = free_port
    pid = spawn bin"lume", "serve", "--port", port.to_s
    sleep 5
    begin
      # Serves 404 Not found if no machines created
      assert_match %r{^HTTP\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}lume").lines.first
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end