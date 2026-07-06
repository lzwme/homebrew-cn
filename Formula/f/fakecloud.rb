class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5c214adfab626141c24b1a52d69102eface11ebd7493a497ad295c334196db48"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "194d0bd7fb96b5e30d4d10fdc554707b79953e165bb26bb13e8e8d4b63572c76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e045ffd759630c7f959b940e22b43665bac21f37361ea98c80a0b8e2cdcaac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49bd6c5112de326242804409dccf1fc6115cabd8698584e34fd5334e77553815"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9c4717efff3d47de9754d91e6878653fe2faea4fc73080f15d19f40181dc44"
    sha256 cellar: :any,                 arm64_linux:   "a696af127774dc67bff30533f8f95124f79952736b7d72f10e6a41f79e5f9833"
    sha256 cellar: :any,                 x86_64_linux:  "9fa5f4f6785e23e2dd735271e847dc5d053d659250f2080c86931fdba55346c6"
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