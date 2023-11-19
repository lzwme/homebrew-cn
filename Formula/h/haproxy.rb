class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.4.tar.gz"
  sha256 "81bacbf50ec6d0f7ecaaad7c03e59978b00322fbdad6ed4a989dd31754b6f25d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "122241968f7309f9566f4e6e133f83141efd9a909b2548021b7ab4086156955e"
    sha256 cellar: :any,                 arm64_ventura:  "615fb8370daae5031eafc7c8dc94855d50305c5c50e337a6c8b14acbe739b603"
    sha256 cellar: :any,                 arm64_monterey: "ea22e39aaeddd523ef8aec1a1749d72ff51006deb3f9d4c228f0d95564ab56df"
    sha256 cellar: :any,                 sonoma:         "e247c313e71620e8c9fc656d4f4ae1bc3557e85007c1fbcd7610fb4986649a40"
    sha256 cellar: :any,                 ventura:        "231bfba74a5a8c02e808bebd7f87d9e9580c36202bf8a4442d391e3cf5d413b7"
    sha256 cellar: :any,                 monterey:       "426acf0e4b822869de2a77556d24818272fd5eaa42c0a9523440b197b2775883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f772a11f9471214d6da682908405bc7b10600c85339cb8db20f56364d1a3406"
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