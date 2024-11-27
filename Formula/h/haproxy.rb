class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.0.tar.gz"
  sha256 "56a1468574ab411dcabde837f96bea6cf3c2eb90e279469f75ed1dcdc70fce11"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "babba8ce9c6edc5720809e5f8f015d733d1c4438cf1a3e75feb2f49f7e76d956"
    sha256 cellar: :any,                 arm64_sonoma:  "2e751427c5e10eb14b2684e30cccf1bf9c456b6c76277e365019890876a216e5"
    sha256 cellar: :any,                 arm64_ventura: "b1fec62ebaf92985170f0d0fc448a72aa4f8aff63168470ebe412155d403aefa"
    sha256 cellar: :any,                 sonoma:        "06fa7b64dee6e08915bfbcaddc2a6c27b4a51bf4fd64dd438c9dc9e67e07efad"
    sha256 cellar: :any,                 ventura:       "032f5b3a60e7b9d2d18270cb27bdfe25d88be9b768d21058a1381e62f22167c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8dec8e35f6de63a3872b4330e2508b4f62ff8e75cf33a68de31aff2682ecda4"
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