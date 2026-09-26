class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.5.tar.gz"
  sha256 "ec5095095bce7db2e0e6e971f616dded1bb505717e692ec6c3cc8dab6a31678a"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0166ce3d19b81651d9e2cb89fb3c36fd13619e26e40d83edba93e623eb87576c"
    sha256 cellar: :any, arm64_tahoe:       "86361587ada777cb2ff3849ccb2fe2e25103aab69adbd15b63a4443b47581d1d"
    sha256 cellar: :any, arm64_sequoia:     "d7bab1c230485c4277fea6a3e03d5bff91d6366e215b349be3932154bfd2908b"
    sha256 cellar: :any, arm64_linux:       "2d42d36946772c05aa63f265f72bfeea5a1e8e489671650be193a13a346fcc64"
    sha256 cellar: :any, x86_64_linux:      "c0bab811d9dc74153567aaa1a3ea495b6fdc7ae3432faa14066dff49c9ce5b5c"
  end

  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_PROMEX=1
      USE_QUIC=1
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