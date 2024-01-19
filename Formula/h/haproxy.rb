class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.3.tar.gz"
  sha256 "ed517c65abd86945411f6bcb18c7ec657a706931cb781ea283063ba0a75858c0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2715988bd4a83fcae9cab0017e318b161e32e4f5b461a5bd07ba571cbebc441"
    sha256 cellar: :any,                 arm64_ventura:  "7c524b262d0305474c16c6f65e2048b6a2fbb7222643b635474a23bc55dd52ad"
    sha256 cellar: :any,                 arm64_monterey: "ad93a1d8fb6b9349dafb3e78842c43f80718a524cc1a29c438145addc2f808cf"
    sha256 cellar: :any,                 sonoma:         "540e244a5baa8e88f002c464012215bb48ba357ef1317cadfd581fcba8592774"
    sha256 cellar: :any,                 ventura:        "e2eea52e58fda635a856627249974229b5f43a008759e96f9c68603b86552587"
    sha256 cellar: :any,                 monterey:       "d7fedecb6beca716c8ed32e803dad00afd8eaad2c2d5ce506c50307ac5f468ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec711dafdac4c69bdb5a11b84e1df9ce64db7860c56e9aed6254e1e2a0a19e1"
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