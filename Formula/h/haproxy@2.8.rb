class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.19.tar.gz"
  sha256 "1c7b8fcc99d87f6e30c5060738e36a4c7d393e1d3c96f5abd84de422a9637b81"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66eddd3204a542dcfa19b3c491d2bd2571c9a4880d3ccd028fc098490e588ea0"
    sha256 cellar: :any,                 arm64_sequoia: "9b7d01cf6210e6b3f63cbd6b2712cd5899dc2adf778c20acd119458c7d310faa"
    sha256 cellar: :any,                 arm64_sonoma:  "64a4cc3bdf6ebc3a5c51a0fd23b8de490263e7c0dee7e0a077b978fb1154ff7a"
    sha256 cellar: :any,                 sonoma:        "597087e1292cb7ecc0352d64cd63d54de8756b82fae757f283083e79c4bbf22f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45101a79e8066eee488ab941bcd4e6dc332f8950c92b7132d5d8c597fcf23132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db819ca1fa740d3d4213a3e00a791cfe78e667f8c94644ff46deeb61c406bcc"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

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