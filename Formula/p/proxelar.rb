class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://ghfast.top/https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "98f65d79a1cd5104c1625ec0bab2edd37a07b6b5114173b1edf358a32970cc2a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e04abc02d35012ca250ddf8994f0b7a59e489bd6f3913537c7419a753f601e7b"
    sha256 cellar: :any, arm64_sequoia: "3afc8e85876f1d0d88eb9597d1bd793451fd24e367e0f1e7c1b67029b70c7d74"
    sha256 cellar: :any, arm64_sonoma:  "2098bac523bc16fa22c21e6428e98a5be2dec269f4d0d19a05bfd49d9febb74e"
    sha256 cellar: :any, sonoma:        "13058406deb73e560a501a51dd26923cf3815ea6ae0edd41bb4462b175c20544"
    sha256 cellar: :any, arm64_linux:   "1ff7ca9292bd0976c6cce91175171eb9da3ed4328861a8dded021f3a57c57ed3"
    sha256 cellar: :any, x86_64_linux:  "fec09a9fa06ba62e64327f1d0e679c8b04cae8cb4d300c465fa0d58045d8594f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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