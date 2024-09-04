class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.4.tar.gz"
  sha256 "aabfd98ada721bbfb68f7805586ced0373fb4c8d73e18faa94055a16c2096936"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39554e401d587932d07597cd3a63634d95a46061e72202c13aefa905c36b6b8e"
    sha256 cellar: :any,                 arm64_ventura:  "b1b0d75c8349802f5a6f62f5c88650ac7fd947648ce6c483c5db0f679a2a7299"
    sha256 cellar: :any,                 arm64_monterey: "d8a25dc42ddd68ea6f19486d351375268287734a314352d99642237b4bf00f07"
    sha256 cellar: :any,                 sonoma:         "59ded7f3349a2e50511f26693c493a6d620ea629c3d4a0b5c19706a82ada1782"
    sha256 cellar: :any,                 ventura:        "4cdbcefa63e0f4c10a4563e3431cbac7d58c55c71386bda55656c976eda41989"
    sha256 cellar: :any,                 monterey:       "e0a1151baa33aa2d8c12cd462e2580f6db4d54853388c4f929ea945e9431016e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9d25005eff1d7a881d3c5977779a8ac6964cf2063b8542a6c41a5c98b534aa5"
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