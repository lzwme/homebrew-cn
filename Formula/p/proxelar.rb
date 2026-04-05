class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://ghfast.top/https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f74df23f56cdf420afbe122a3c5992bf24efa63ca0ecacd9b01e4bbb204ad7a8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b495e25c4df9de87aaee9e31e7eec5d1b0d97a9495547835af525825a05a0bd3"
    sha256 cellar: :any,                 arm64_sequoia: "10a65ba497f5a800672f9f4200de414c8389c4419a485663572bcabf5ea660d0"
    sha256 cellar: :any,                 arm64_sonoma:  "845bf504a668ba58bf1c6a89d08972be063e99f550a350bfd38b85a2a6aeff77"
    sha256 cellar: :any,                 sonoma:        "d3cc648a32b2ce9e3991ba94a91be3f213ce31e7b04230d342d57af5b0bed0c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46332d085a5c9849edd808f4e4d4101b0cd9d3fb4f6f73c2db6c9b51860ee13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920d9a1f3ac0b3358e2c6a9ffe5028e9bb76a7514b34ac370cc253995880576a"
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