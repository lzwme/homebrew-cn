class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "7d5b1049265def497901fe21aef5024cb2a50b198a584d14cb4a139db090d0f5"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a488525294de8baceaa3d5641141440d1ccf5a803afdaa923618f507cc1ee36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf2791b965867c0982e576f48c85f85aec6456414ade42f41abe3263dc37efce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c303ae021171729556dbfd9ea7be85f7a44b42ff0b097d1143b2d004a39066f9"
    sha256 cellar: :any,                 arm64_linux:       "454351fc30a1b242eaad7a85ebc030da535846d68704bc4e12220f1a15caf8d4"
    sha256 cellar: :any,                 x86_64_linux:      "e309e6d1d6e0992f62c50a16488661f6cc9dff345b5cd0717afe4667153339b3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  # Test binds and queries a local fakecloud server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end