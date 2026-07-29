class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.8.tar.gz"
  sha256 "70a6c0e1c22441c2eab253690aa3f07a6fef627547f1a60422faeda2d6ce8f83"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98950c2a4e284f4012df8fe5ade4c98e8063a2916a83f080d360d2f4067c7a98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329d1dbcf01174a424f79b94e2dbf81e8ad2b890b94409faf78cfac6fff6e2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "410fd2ac90eb005c1179746edcef4377a310e4b0cca0dfae50da32b0dd477fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5da0270a23d98054e214f443b0ec36e84c065ccab8aef8286a580713a5348ae9"
    sha256 cellar: :any,                 arm64_linux:   "8f11ce7f1f3c10cda01f9fa5815460552a48e2e56a02fa0122a5c8d668e93672"
    sha256 cellar: :any,                 x86_64_linux:  "1e31d4f480096e6a08bce43a66073031d7d4cfd15a8fefd6740fb18d8681737b"
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