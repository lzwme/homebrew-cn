class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "924bd87a6ca33494aca84ea395d18c71bcbb5319fc879ce169c83b24cc6c6443"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f7f8f92e45a191f073d7e1bacd7f5b442dadd5ee4eb685eb63a2a1754ad9ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cbe6f99b87df81e3fea55f536f52e22cabd23129ee0e2c6450df6f2fb30e654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed66d4e60f2ea28f771c1fd9e38205d05ab54f8a3f1f9f5566a8ff287c22d3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6e09b37b4eb7d7c835be2139fd076bd0fffbfb8c38ec3f79a71f98e8e98538"
    sha256 cellar: :any,                 arm64_linux:   "14b7e219bfae97ad8110d9d12854cd6d10c66f79677558660f6953b83497c7b5"
    sha256 cellar: :any,                 x86_64_linux:  "5557370e9d7112b697d5123dd4561b6d07cd0142c636f9709b683264ab0ae17f"
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