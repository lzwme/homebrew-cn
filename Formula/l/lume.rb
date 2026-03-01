class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/cua"
  url "https://ghfast.top/https://github.com/trycua/cua/archive/refs/tags/lume-v0.2.85.tar.gz"
  sha256 "2671acc92d7808e81e2bb0e86f6e32fc1bebb443fb45a5773beedcdadd8a9e63"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24992e8949335cedcdae92597dac96dc63a71b55d4e2706f18f98f39e4a6381e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b55776529b7a7cec1c0dfb231a01d298a037cb874935018af73585c781b0f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8a4b3ee98cbee2fd772fc1d595dedaee8d7dbbd5d1a12a5d51bb4fda2cced1"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlements", "resources/lume.local.entitlements", # Avoid SIGKILL with ad-hoc signing.
             ".build/release/lume"
      libexec.install ".build/release/lume", ".build/release/lume_lume.bundle"
      bin.write_exec_script libexec/"lume"
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
    # `setup --unattended` loads presets from `lume_lume.bundle`.
    # It should fail because the VM doesn't exist, not crash on missing resources.
    output = shell_output("#{bin}/lume setup does-not-exist --unattended tahoe 2>&1", 1)
    assert_match "Virtual machine not found", output

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