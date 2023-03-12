class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.4.tar.gz"
  sha256 "84cb806030569e866812eed38ebd1a8ea6fe1d9800001e59924ec3dd39553b9f"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1bfacf6be3e44d9b36ffaaa2cc055085c677c0c057e7feb5fc70c4c6a1d0eda0"
    sha256 cellar: :any,                 arm64_monterey: "f8866d02789f748eec2d72b6477e1ea888af50ad57376863f9ff241f152a1ca9"
    sha256 cellar: :any,                 arm64_big_sur:  "5b2214dbc4ac9b4f48a782680eae128d190792aacf5311a173991fff316800f8"
    sha256 cellar: :any,                 ventura:        "ab1c1c0ff424d6386151c9f893a84e94a07108b349eaffebb41a73423ec87723"
    sha256 cellar: :any,                 monterey:       "ffc36351845511b5aca41900741946a7ac08f80f34c51fa362f7a1f2a6ab8eac"
    sha256 cellar: :any,                 big_sur:        "d227c71ab8a0ba74c7649090b2e3c4ea54c37447bc1c937ce62da19f4e0bded0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c34b0b9790fb6668b5e8c368f1248c552d3aa4fe74d05638e71aa378cc73a4"
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