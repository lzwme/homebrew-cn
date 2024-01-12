class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.2.tar.gz"
  sha256 "851aee830ec28c1791246a9fd4478f643d115a563dd907f6612cc381a952ab3c"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d98661fb3cfdd97558cbc6d331c5ebb0ea8a264ead9c24f9093799e96b2301d6"
    sha256 cellar: :any,                 arm64_ventura:  "c8f9694c54bb146864344eb3541ed99e2245f00778e63b75dec4de10b31507df"
    sha256 cellar: :any,                 arm64_monterey: "bf01bfd5898d4ebe858c2cee80e2400a956649751b422aab48283f10ecf02178"
    sha256 cellar: :any,                 sonoma:         "7de5f2fc74a5d6adffd3283528a2aa02263495eb51ab1d6d15cf5724c40916a0"
    sha256 cellar: :any,                 ventura:        "663a41327157afa485b85db7fa548dcdddd38f6fe2dce79c1237a3620368092b"
    sha256 cellar: :any,                 monterey:       "ab27485fb4dcf514c6a315ef02214865b5ffdc02a9da05b69d305b94ca0cf292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6355b4a94cb8ac3ed12825e58601325e75974754f922fa19fae40ba468c63233"
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