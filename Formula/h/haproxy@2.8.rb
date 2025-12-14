class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.16.tar.gz"
  sha256 "6eb4d3cc298af89613fc6cb175530436e1e463d368e43401a60357a7a12d15ab"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "618d1f8ce9c988adf68473b2f63f382074976e5b88e73555ebea81ad821d01e7"
    sha256 cellar: :any,                 arm64_sequoia: "af521c82ad16a2c7d81e04ea88eb2651fac24aa3ea4f949454a1055f95d8a0e9"
    sha256 cellar: :any,                 arm64_sonoma:  "ae3fa6c1d1ec7e81eb5d2cfe51331e047d3ec9f5c5a33787cb7680c76d4613dd"
    sha256 cellar: :any,                 sonoma:        "ee3de6a2da71f8ab05acf41a6ef0310f7e93f1ac8cd4521b90d2fea9c96650a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7376146ac99a68be3700128650a6bfba3e458cc12b03c785fd181c91cd60d631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9746d92c0e25d0313387d06b8616e7c322f6bb946f9fda02e6f923c90952b8a7"
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