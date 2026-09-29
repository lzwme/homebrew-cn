class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.6.tar.gz"
  sha256 "791e1815f8af6e8b850a227a9a0a190f3d3478c9e8d38a0f51c98b7f4bfe368b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "362f9e707cdb8e445813c08d5fcd38a7b4325b3fa03984a77adf64d3a6ac5d58"
    sha256 cellar: :any, arm64_tahoe:       "2e48c70531144e6c967e67349519ac705a5eb780dddcea5763608fb1c8889eb0"
    sha256 cellar: :any, arm64_sequoia:     "03d451e9c3206982fcc4287a97195ae03fd2411af992c65934b0291d05f445f5"
    sha256 cellar: :any, arm64_linux:       "6ba7de42085486438b480b0aff2d87a50c579d441719bec9ab9ccf5a2b512d5e"
    sha256 cellar: :any, x86_64_linux:      "c761a0f4f54d548967bf3b2c089cfccc493f81f95be5ea1b0ece080b54ef7a78"
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