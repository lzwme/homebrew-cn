class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.12.tar.gz"
  sha256 "16c16c1d7ba6793c89a8fae7f20c595d19497bb18d75fedd9f2db77741b1fa75"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fb522bb53acc24cdfe84205af8ad35373125a1b3659e3fe56e91be99b0ec82e"
    sha256 cellar: :any,                 arm64_sonoma:  "e347343a43dddcc239643c3058c212a5dbd60baf8c2b76dc8d5b57b72d4fdec7"
    sha256 cellar: :any,                 arm64_ventura: "3a1691dcd48c96339d8ef4f6064b5e8f4974bbbbcbd23722c93805a48d80ccef"
    sha256 cellar: :any,                 sonoma:        "df6033baff96005ed609993c6b0f42738cad9995311ed99dfccbf843eb5d9c0e"
    sha256 cellar: :any,                 ventura:       "9c8c0bdb81e445d742b8a2f1a48fcb8ca9d5565d680aa66f0e11ec694ea48ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ec714355176deb568d035613381ec896c2fb54e58535757bb07a2cd58ebc4c"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

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