class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.4.tar.gz"
  sha256 "9e89bd0728b269d200dcfe3cdef3b5c8b21ea68bf14ad89e3a6f76bda701e7fe"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0eb31f773cd6629f5f24e41a94041e6c33e5c3ae5a6c1c252a4994faf6f02616"
    sha256 cellar: :any,                 arm64_sonoma:  "eb7a920351800eea5e424ba2a675eda715f06d515e841ac2d69832ddcefd15e7"
    sha256 cellar: :any,                 arm64_ventura: "a18848aa265077491c86463ad815659274c0eba6797e750c3cb287925ff85e09"
    sha256 cellar: :any,                 sonoma:        "c4015b4f4326ba57d82371255009678455548846f138b342be1c385d20aee027"
    sha256 cellar: :any,                 ventura:       "ea854f603bac007cda3d6a7f4f387f4f02cbc57a06fcb1cf3de437f7062c4f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c11cbdd257d5bceb3adfd2d00290685e471c7a51b28034c23da4e2516dd938d"
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