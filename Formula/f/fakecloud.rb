class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "d21e19ec16193eaebdaeb8085bd23874ea599dbb3ac617bcd63004d50469e82b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0c7e6c41d72bb2e82ae5fec70589d93976cb1a292abe3b85621f920e653cbc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52709edf0fea77143e89cd114e6150f8994c3f6da6a3b27d9d2bace9b91e7ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c67033457e555b0652a3e887701c59464e1144fa58b6d7d86b9a89600f26d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a8a0e91634decad6455acad635818138bac82d26cd15a46b90fc2a1535b73d"
    sha256 cellar: :any,                 arm64_linux:   "2a328e6f4c7ec8b9e4570c2e390071ea6003abb5502408bceff1b8ec61ec6c06"
    sha256 cellar: :any,                 x86_64_linux:  "fee69a3294c581fa7034d0c295b32853d84a0dd947d6b38b201d8b615f7497d7"
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