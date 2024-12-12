class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.1.tar.gz"
  sha256 "8c1b5d439ba4b278e602445c57e20067adef214dc9c44c2a1cf172fad5f7d273"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad2d904a15e41d0ccaec4e84479f5564dd1a02d1d8d97204bb85a066aa3c8a47"
    sha256 cellar: :any,                 arm64_sonoma:  "c8cfb98b042125c840b7219b63038f2934478c538a7fef09e9df04e2268d5a23"
    sha256 cellar: :any,                 arm64_ventura: "5a1c47abac75a7d74423b9df1eb229060ffa56ff8e40c22c023a4f66f075e3d9"
    sha256 cellar: :any,                 sonoma:        "d1275dfa04b28663580177cc8fed8ba4f3d462f5fab56d86864666138e4c6188"
    sha256 cellar: :any,                 ventura:       "9603c06bb31630534b5336e5d04aeef6571c226b9c35b5d1cbca10b7fad75b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4f84a833cae721d41f94eac864bf1ea75316dc9041ad4e3c085e4ecfdb3eca"
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