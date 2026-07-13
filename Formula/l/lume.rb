class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://cua.ai"
  url "https://ghfast.top/https://github.com/trycua/cua/archive/refs/tags/lume-v0.3.15.tar.gz"
  sha256 "101a9c6f354dd91dd7547ef483d58c4139186753d6a7d5321da2059272cb9b8f"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86d5ae740527d4d54fcde3b5f006242eb92b7b5c650e6b0f7dc17e2dbbec202b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e88936a84b792fb5138ad3e85fb8ce9f12170d84b562082f5751e6b5675f284"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on macos: :sequoia # Swift 6 actor isolation requires macOS 15 SDK

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