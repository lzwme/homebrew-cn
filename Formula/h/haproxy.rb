class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.4.tar.gz"
  sha256 "9c3892cc3c084ac4f00125ef22a151cf181416d84aa8a37af6af6aa0399096bc"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6db09e84f777a37d01b078668fed3e52140989b6a697c55e5a51f56d27930738"
    sha256 cellar: :any,                 arm64_ventura:  "ac770eb66c9ffc3b2b7bbf9afec0063cc70a6a0067c2d29a2c94f0ca68e8a886"
    sha256 cellar: :any,                 arm64_monterey: "b2b2fa85c62a22077f97683c50e2bf66acf331dedf5fc34c30b26b666f5e40f7"
    sha256 cellar: :any,                 sonoma:         "247a5499cb237505b67a7c185ca4262988a3ba3c7ee58eb791cdc19b3dc205eb"
    sha256 cellar: :any,                 ventura:        "fb59a084ebd9892c09e5a4bb7b382be5d33f435a7c24077f098741769d728de1"
    sha256 cellar: :any,                 monterey:       "eff1be811026fc98d6bab267753a2873ea25ac11eeb066d94d3886a0bf723f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6f4d925d42734ef3f22e17dbccb2f1d94607e6f71e0eb819c19ff4edb312884"
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