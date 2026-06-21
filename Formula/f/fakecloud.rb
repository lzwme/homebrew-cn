class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3b7cd4aa30aa9cf956c492e08f5942e659fbe85fb9c991c29669d407525a6ce4"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65273e7e4287bff8c239776e5e5c4d71e0bb9bd8398a8cf0a13b96c8c6a3feea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf060ddc5af473eba58af6298be1111e4f26c3625729cc571651ab13f19a8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19317f4fca5676acb961d3ff490af1ccf0530084ed8cb3800ee45016bbaa58ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "706309355cce680fc4425fe2c0996619c29d1950a4b1c587b83fcf25562cc1eb"
    sha256 cellar: :any,                 arm64_linux:   "bff6d1326332316a8c9f0af630b274bce5f7cc128247224913a178c7dfaf97f1"
    sha256 cellar: :any,                 x86_64_linux:  "5b5b1c70e739f415b9c8e3f75ce00a6623bccbdd62851e6319b6807af3c86f6f"
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