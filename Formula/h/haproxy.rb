class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.6.tar.gz"
  sha256 "cf1bf58b5bc79c48db7b01667596ffd98343adb29a41096f075f00a8f90a7335"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9f09dd224dbf69a9e2c497658def0bdbbf7c5b86e1331a3f12aa1fb4f25b8c3"
    sha256 cellar: :any,                 arm64_sonoma:  "242152366296f367e7e0c9897d63ebe7bf9a4f883d57b2e746bc9d410828cde6"
    sha256 cellar: :any,                 arm64_ventura: "b562bbef8b2a0ea99f404f52fc3e7c436da94650a820e3e37c5c6a572a358934"
    sha256 cellar: :any,                 sonoma:        "c7ed1c767b774ca3de5f183bc2de63ffe366287246f89eee27377e3a600287d5"
    sha256 cellar: :any,                 ventura:       "a720b103ffc4b22f16b61785d77e4f4a5c4c2cb0a69f070a4a678494b0027f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0dd7f4557b5ef7f8705c55b4b525c72b8627b04a90efe58b277350b1032eec"
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