class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.4.tar.gz"
  sha256 "5063eccd818a0bb131a7529ca9824da952697fbf777de0c8376ad610a66173ac"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c2282c9b6b1c327ce7aaca383b89be3b1777681a2c57144e0dfbf9e66b09d8f"
    sha256 cellar: :any,                 arm64_sequoia: "0de2b603ca48d990b2980c4375d8926bb2d3628d5f87938b5caffd0449edef5c"
    sha256 cellar: :any,                 arm64_sonoma:  "febdf45ae66d1fa89de64d174a3e44624e9ca60e0b4fd4732e2553d6a32fbd50"
    sha256 cellar: :any,                 sonoma:        "c333f80071fb587e85167a870cc92976c2178797c6f7ff8fd88445ae74a09a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "425ee555906a34702d0d86686dc4bd40b30cad964f21abe1f1173071e5c86fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9700d93e54a5521264fa64ad0229707187d45e0a04cd2f6f4d6bad4b17554b3"
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