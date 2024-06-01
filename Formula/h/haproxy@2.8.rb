class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.9.tar.gz"
  sha256 "7a821478f36f847607f51a51e80f4f890c37af4811d60438e7f63783f67592ff"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e87ff40bc52b27f3092587eb146088f0a2001955aa593888a4b980969d79de8"
    sha256 cellar: :any,                 arm64_ventura:  "9097e1a1e762e2786ae0ca1518d6f5e0140ef9059b7230565ae0032d776f7756"
    sha256 cellar: :any,                 arm64_monterey: "237e7951c019a459194a7e4130f383392b4d60039050cbe412fbba8de85dd3e5"
    sha256 cellar: :any,                 sonoma:         "7a1366c470499a8597ac3922c836db54e115ce46437df072cf5629706c92fe49"
    sha256 cellar: :any,                 ventura:        "7086eb033df6e3c6efa50d6707e06259ea0a0f45e013ddecd546c435444a8000"
    sha256 cellar: :any,                 monterey:       "236ec94341a17dc8ada809c5bfefe4d4d17b58d0ad5bb1d51e499d09d6038948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e931b569fe026381165b5e790f9df6dd15db113ebf03f07332b6822b608457d4"
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