class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.7.tar.gz"
  sha256 "1f0ae9dfb0b319e2d5cb6e4cdf931a0877ad88e0090c46cf16faf008fbf54278"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "574109f818011bd1d6b54e41a17cbdaad86612d7616ac19dc2adf26ea4162ab8"
    sha256 cellar: :any,                 arm64_sequoia: "7793ce18d654190225cace2961baded97d886ff61ad5d935fa2688d5e2474c27"
    sha256 cellar: :any,                 arm64_sonoma:  "31b8322b435277d4fd468a25bebcfbe71f6687913acd73114192d293153fa459"
    sha256 cellar: :any,                 sonoma:        "e9430e38a82518b7f2a9d5b277e3087821832bea795313841e9954e6e01b0229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c594a627bc12803ac1bcd7df22ef150394bc793c528c6e726b2e55441763042a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ccfde18c340ad0f414a963e8e8106dd29b29247311792c36e1a1d06f21d9b4"
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