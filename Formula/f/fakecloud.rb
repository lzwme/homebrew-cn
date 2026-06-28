class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "f82db9008bcfe637c6c4e6bd2d655b5632804424db1f7fd98ef50aedd1f533ca"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9e272a25e94cb82a17aa614b1474ee5aef15cec29befb412fd9e4c9494c6a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc572f4d2be1f1059f8db211273a81cf47f57b5f43a1d7c8f6ab9bfdb51ea5a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3026489aeb1a0d54373a6c33739c60e2e3d8ccd587d0801b82a456d82228bb6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4af1cb6b7951a53c11b194f82d5b9c1c8c7b16bd8d00b8d1e9800f89eeac9c59"
    sha256 cellar: :any,                 arm64_linux:   "9649c24a33755cacd0e90584fd6ef54d0a6bf3aee20faf686132789578e53581"
    sha256 cellar: :any,                 x86_64_linux:  "a6519474771d3ff40b690f7a4864a3b8f4c0a71b0c4298bc0d0804b116d2140d"
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