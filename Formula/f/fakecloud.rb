class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "3a6bde1ec163d26a54fda6d2ab6557ecb3c444982af7929cbdbf2f9d7db142db"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ccc1a2102ab6f18934474f1dec4b9dc14cab7a4c7cd7cdbfd812fe0e488406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1d5bc5939a5e7ad0f0496b8e3667560247150a774b472a63d507629dab97b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeeae58f9dcf402979b52ec04402535182197e98fe11800d60a8e8dbd0b5ddec"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ab26394dd492e64f9b2ec2235d6a48152ffec0b978cb3fd44c954de084d986"
    sha256 cellar: :any,                 arm64_linux:   "4cc2eff6af522d4fbd02de733287cc1e5ba756da5586f89a7b60ca2e3ad0ee73"
    sha256 cellar: :any,                 x86_64_linux:  "5c4aac8dd73eda54a7be2beb28326903e7f91540faacc3e42b6b1e91d3c033fc"
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