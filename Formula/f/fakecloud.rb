class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "6727522902687ee96c722f73eea19c9ad82e734db296989635610ec77d2db862"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e1ddc98d7ff1331b757022837e3b9c24cb508243d01c7994bb0ea3ec5c89c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef22651c838768d070023c02aee466af25d8edb36ba024cd41bd4ff175a46b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "861f4b1dc230e0fa0c7d368e1efef1ea7342ab9f71ac1d178dc59915cf1ed53f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88d20efbee396686012759b47868d1bdc9fb3324f452ce1c513c01c541a9ada"
    sha256 cellar: :any,                 arm64_linux:   "02598c230c0b21218c47357267577e4a44a4c2fa5380f7111164ce750ae0cd8c"
    sha256 cellar: :any,                 x86_64_linux:  "3afbecb55566632d9555a60455b56e039288f58c3800b6ae50855bb92f965696"
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