class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.0.tar.gz"
  sha256 "fba18acd1a46337fe20ae07c816c2496c8602b80a1bc9ff3768d4caa5fb80eab"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c640edef462feff551a89e5f741e1cb7bc75288362ed6588a52c1a9efd1432c1"
    sha256 cellar: :any,                 arm64_ventura:  "8d7e1b8fb2a3b1dfd197bf498d60fc0bd5d5f8311bdaaabdc2508bad36672e0b"
    sha256 cellar: :any,                 arm64_monterey: "2708cfc558358084500d87c5cd08e89b629ce3228c0915765b56a94300b93a0c"
    sha256 cellar: :any,                 sonoma:         "0aa7fcc62c604b36bdd97f357da6980d143e5192d3a292a0c87db123bee32b1b"
    sha256 cellar: :any,                 ventura:        "fe2a1ef44c77988ea974ad8c61369404501930987ef2d0ed1ee34fe8e9134d84"
    sha256 cellar: :any,                 monterey:       "4fd2c49afe08868ec3c5e74ff0354e708e567101a71552e15583fac39dd58cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4701ccbf66b2d816a7a6731ba0aa4b62fab8fdb0723b3aae7236346b6f8fce1"
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