class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.17.tar.gz"
  sha256 "b21ce060098580d163f8c16b7bdb5b135a59c1092b1b6cc1f33eb961d89c573b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63547a24adb46a1ebcdb466fb14d530d4b8c465293ec1afd8d24454de983c88e"
    sha256 cellar: :any,                 arm64_sequoia: "8b04636636c7dd5e8482c0b6a99974597963c9e31c7aa1b71de46ac101075f38"
    sha256 cellar: :any,                 arm64_sonoma:  "fce2bd684f62ea8e8c4c403fa6a9c52b1a6b6fdbc2532d8d715cd368c820f9e7"
    sha256 cellar: :any,                 sonoma:        "4b8beff57fee44aab6f16026cbf8e84cbc47e84aa7f07c723f2d7fb1b4013757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a0a3d306f435fc76ca379ab667a74412bbd97d107f6d90b54b7354ac04ad6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca62612073a5bd84cdf2b966fe2fa3c497a296db01b8083730fb753d2f29f934"
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