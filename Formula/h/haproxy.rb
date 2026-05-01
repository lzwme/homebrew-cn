class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.8.tar.gz"
  sha256 "89b1fe73d54d5990f74997da837f5fd0da1627a1baa62b26f5d358a6f3c48295"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a63a9c0004faadb36028ca7e28753f04df28cf97a0e60e8c9a521109444f2e39"
    sha256 cellar: :any,                 arm64_sequoia: "c8089598b118c9919dbe2600d3538fc8316b45c1a6e71ae1e01cdc7f6ae4a24e"
    sha256 cellar: :any,                 arm64_sonoma:  "d0538596fb29a83a020db79dd57a236dd7d4de32db03cfce6a6ed11c26cb3644"
    sha256 cellar: :any,                 sonoma:        "d5610e565e4a93067e3bc1106d8873aa22fa3cab3896b2e18f41f71eb8bd4e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59eb863926a092ddb369f596e4a80b28c516a162f8399543a96a80b438b0e071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b74aba5708e69de39f9fcc9e44d4cb4e3b0822634845b6c55a448ff529f1794"
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