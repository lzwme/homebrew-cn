class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "a04e3e9165052a831356397de32d7f0f4e76b46087c57302e1517a0ab54045fc"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f1ac58695cea9d8ff6884fc225539ed373859a3f08645396d56ec16f30bd5df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c74ada655a29315c22da66d676850f2435dc68c322a6430847dce9e2291557de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e059712d075c8a0c1ef5ac01f2b2437c939812777a9f6ab7a8890e1e84c70014"
    sha256 cellar: :any,                 arm64_linux:       "f2350e89dee58bb4dacf7109d34dda059311f287c676cc4e7efb98f1fe205e88"
    sha256 cellar: :any,                 x86_64_linux:      "d65b86a70aad3b85a5367d34a4d4c8ddd31c5be71db642e279306bb0e7e8674c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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