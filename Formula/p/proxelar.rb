class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://ghfast.top/https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c76944713bc01aea302b28bcf044ea5a7fcde7a7d7c2523904724234880cb647"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cac2cf644e2332dd91f18101d60943f0f975ef146f1bcdcb8152b38455c8199"
    sha256 cellar: :any,                 arm64_sequoia: "b481165c58341db8e8024e456fd6952ec46cb3b42354310514cd8067b8ff2c43"
    sha256 cellar: :any,                 arm64_sonoma:  "4719af1e043a7d21b4c185b6291dc33108bacc7cd5dfd7418101138cd7596548"
    sha256 cellar: :any,                 sonoma:        "a853936783d090c02d927529d1d097087d12c0571461d8b49ed7fdb143a2be27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81bd4f5ea3625fe829c7ace10a4391aea5c53f5c1cabf88b72ccadb5ed49b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985fc058fad3f962276e55c0ee4555fbe544111f98d881e05052ecd879bfa9c2"
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