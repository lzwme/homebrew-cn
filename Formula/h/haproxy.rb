class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.2.tar.gz"
  sha256 "7295cbc26cce19434494d54d9a810be8fdf3d35014b2ed3238bb4851a63792cb"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "94c0d8c675e964e6d94c79542fe2524e84d89e10588c11c46948b72237856dba"
    sha256 cellar: :any,                 arm64_sequoia: "c9a5d6df22d403bc1da350e8effd42f20e110444412a8459e87419b2578b0676"
    sha256 cellar: :any,                 arm64_sonoma:  "f29fe6868d654ef82c167d5c69b809b989f0b671c2b82d5452b8f7bd6d75f95a"
    sha256 cellar: :any,                 sonoma:        "97ea8f113a9a154357c92436e72f9fd8b49434abdc219e6c3c781f76b7441b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "337fc29b7fa60cb230a05310f2aef04b80ae75dd433a565d52100a99322e42fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341297a8f5c63a0fba544368a50dc39bd1b6ee8e8ad92b561f9dc37703c78f4e"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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