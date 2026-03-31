class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://ghfast.top/https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fb2847760c04e8aca1775d1ce475ab879b71c248f29a68056fa5927d8f239c04"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf76be0ada6a84169aec0078ab7e8eb89166736d2694bbcc332a2da220be12d8"
    sha256 cellar: :any,                 arm64_sequoia: "8633760b584c7e83b1022e5e908f96a8384a5df5897cc7a3461fe41026789003"
    sha256 cellar: :any,                 arm64_sonoma:  "463dd734f3df9492af14aa2603d3218e25357a9aa82a1d62f2b4bb2de5f44f73"
    sha256 cellar: :any,                 sonoma:        "4a9563591f9548c805a8870bec327d5a2f040e0bc499b8ba4ebb3e0a964a73a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb4f375f63e4a3a0164ddc9753148d211d859976c8455730a068572cc323915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d207dc3c1ce16caa0672ae050adc7b2bdceb183b9d4d9bc2ea9acdefaf3aa9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "proxelar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxelar --version")

    port = free_port
    pid = spawn bin/"proxelar", "--interface", "terminal", "--port", port.to_s, "--ca-dir", testpath
    sleep 2
    begin
      output = shell_output("curl --silent --max-time 5 --proxy http://127.0.0.1:#{port} http://example.com/")
      assert_match "Example Domain", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end