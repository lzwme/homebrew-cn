class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "143a65e81c4be6000b7c5503785e0f4c5b18a0b31cd2107d4cbfc15706b68397"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa3c1f17b610573c5e24599e696d5fcef70386e83b7aaa1d88887f89d281c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e76f61a3ba620ecbd3fcc13c2dbaba9f9a96e5308d207493d89222acda307f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00573629eeb5c9f2e368351ab5cf313ef2bcb53643b2b6d814ba280537deef94"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f0f137161d1afd94d5ebe48469b25c4b44308d659d4ebefa87b1f60760a12c"
    sha256 cellar: :any,                 arm64_linux:   "143f67a5538cf0cc9601588e3ac1b566de07743e83017476c63e1aaff9116aa4"
    sha256 cellar: :any,                 x86_64_linux:  "e296768dc7e9943001d6d5a204372999932e9b3cfb73301726535d744904a14d"
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