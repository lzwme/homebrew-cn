class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.0.tar.gz"
  sha256 "5aad97416216d2cd9dd212eb674839c40cd387f60fbc4b13d7ea3f1e5664a814"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d44cc834fa88f8173a122d476e0c66a2a5d5fd6c7bf2a86dfd5493fb62dc7890"
    sha256 cellar: :any,                 arm64_ventura:  "c88b98b9fdeb4032121be99a4fece8ee6ebcead84e41f0e3c940f0475fdee168"
    sha256 cellar: :any,                 arm64_monterey: "4b9502821ff1085e8b09b187cd8c0a47e25d269f1fcf18d0ee21f1d4a11189e2"
    sha256 cellar: :any,                 sonoma:         "e07ecc654fea17e437f7fd2a5aeb60e160fa062fb5e4856226ec26bec946eb66"
    sha256 cellar: :any,                 ventura:        "b6821eb662cfad9881ff529d057433c7d7ad44c47617701adeaab385a90a1779"
    sha256 cellar: :any,                 monterey:       "1edaa0d28640cf740452d6c482c2659c2ffabec79cc5a48df8a9f3542233f647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e32e85fd1fc31dd06db02e0aea25d5139826e14468bd089cddc2168f27e334b"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
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