class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.4.tar.gz"
  sha256 "b0c5053c4d46840ecdee3925736fe9a3de6472559b43c69183d70e593d9133df"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d33b4205194dee55b06840e506b6ffc4db2536b9ff52d5dc803d0f48b866ff5c"
    sha256 cellar: :any, arm64_tahoe:       "8e63267aa8ee9425d5596cbc98da9da2b98868120c62e0a26949c3654716b0b4"
    sha256 cellar: :any, arm64_sequoia:     "0641579a28186f277ca5eeb072f539d10b47b34595d0149d49f1247a1501da6e"
    sha256 cellar: :any, arm64_linux:       "1f42dfb4dd2314cf6f7c5f7f56ffb087e669176cad0da1f19c71f5c352b4a661"
    sha256 cellar: :any, x86_64_linux:      "721f6d9fdd4d09bd7e8a0529b4de62756d5661370612ad0139feeeb0656d746e"
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