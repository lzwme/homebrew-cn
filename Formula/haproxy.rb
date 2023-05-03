class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.8.tar.gz"
  sha256 "15f2276971bbba8c47d86cc82ebfc6ec33e3aef2e4565058b2e4950c07b8e75c"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dfde8d00ec028c92e39164da68aeadd28457a45e54dd84d18a017d3018c5b14"
    sha256 cellar: :any,                 arm64_monterey: "5d1c5179bf6a309cc66d565d5a7c0c91fb670d1e0993571eba909ef0749d24e6"
    sha256 cellar: :any,                 arm64_big_sur:  "b3edc98f5041968c18e30242d26bb039e8f8e3776a92f0233add9c2a06e7ee8a"
    sha256 cellar: :any,                 ventura:        "bacff0b4c59357be353685d94c76c8a7bdbd5bf773adf1028dda04bd79faab58"
    sha256 cellar: :any,                 monterey:       "f082a41a0ff440f950d1a1f94b22365ff4493007e1f5125a390020f76b5b9630"
    sha256 cellar: :any,                 big_sur:        "13bdb8c59e5745663bb75201688437130895ed65ea945e6d5c9bdf6ca913f3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea00a572f5385ee6df351862612105a36f1ec5c1ba1fef6c34194940177bbd55"
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