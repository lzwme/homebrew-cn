class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.5.tar.gz"
  sha256 "36e2816f697f389233137dc7ec9559faa7703243395ad129af091b63f4f099cf"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "361336446aa2ff919bf14a1ad3c5e2d76533feba7c953bd7bba7166db2d65bc3"
    sha256 cellar: :any,                 arm64_sonoma:  "d27b2b506467f29ed18fd316aa497650cc37afdbdb1918b8952341f1edf8bceb"
    sha256 cellar: :any,                 arm64_ventura: "4eb7f5dc6e4f67337f810e85e0febc8d6c4b8e70a1ed30008e3d678bddf3482d"
    sha256 cellar: :any,                 sonoma:        "db2eec15a2583a3a604fc205583111fc02074e8506322512e939d0d5306f54f1"
    sha256 cellar: :any,                 ventura:       "2296c0583d0a432d00720e1b993c79ba6d153700d9adb45a3dbc27a457e92e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762d95faee38ee410431d4e3c219abba001a002f09d38d0f421795cd6edb0d15"
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