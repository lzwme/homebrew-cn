class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.5.tar.gz"
  sha256 "9de6e765b426f07c1080aadd2fba5b682a1cc175fe8eb45d5eb948292a866e02"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccb761d25a9b7b0801aa60055af02cd5997116c60a8b12ce26a4dc4e22898d0a"
    sha256 cellar: :any,                 arm64_sequoia: "228d71e63f1fbdae9b4bc39888923bb35a7051e816898807d7e6af43b01c3845"
    sha256 cellar: :any,                 arm64_sonoma:  "01fa7a78cd989b687c6e8857bf2c8846b001a12b1700d9f4a8ba459fa807ec4d"
    sha256 cellar: :any,                 sonoma:        "3cd4453277fadd23d83e1edede242101ea40489abd01a660aa39e6dc6249be52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a20f5088fd4fbb8402c2604cc01578d8796bfef6024db802649ff368962b56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7130306c1d20c548e008fcbe2ea6bdc84891ed8cfb611658771ae0a06ae3b39e"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_PROMEX=1
      USE_ZLIB=1
    ]

    target = if OS.mac?
      "osx"
    else
      "linux-glibc"
    end
    args << "TARGET=#{target}"

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  service do
    run [opt_bin/"haproxy", "-f", etc/"haproxy.cfg"]
    keep_alive true
    log_path var/"log/haproxy.log"
    error_log_path var/"log/haproxy.log"
  end

  test do
    system bin/"haproxy", "-v"
  end
end