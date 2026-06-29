class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "d9510dc0c9c93e55e48a5470373331b849f6d154497b9334218d79be238c77e0"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f0a97e38cafef9aa521291db9fcc6dcf75a65356dc4aae6e33d9cc900bf8be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa201cd7a60d3799c88a3794269b49be0b14431f76b14239003fa16b45d0667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e994370cd0c1f62b9443e3f7c993ad48160f45abbf50f726f7966ae55c773fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e13c1827589d4355eda3ac608f28a4d6456c90c2dd4dcaf0d3cbcb2923b13fc8"
    sha256 cellar: :any,                 arm64_linux:   "ce7b8f00b5c9073c4c96330d31d729544dac2c18ab52c0092688508878069fe2"
    sha256 cellar: :any,                 x86_64_linux:  "d9082aa2a02cd33fb6119c9d600ee365d878ffd407ec06109f012603f8fd193e"
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