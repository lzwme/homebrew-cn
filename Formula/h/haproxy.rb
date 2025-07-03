class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.2.tar.gz"
  sha256 "be64ed565c320e670bb909c5834f90303c3ec0c97af5befa45994961aaa6c6ec"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e437ea931031a08750eeeeca1e5f40530ff35d4c614402a2f25a564103774c7"
    sha256 cellar: :any,                 arm64_sonoma:  "6b35c304284f0565443575a165858fa7cf4f4d323ba76fd95574ee12ee83ce8b"
    sha256 cellar: :any,                 arm64_ventura: "18af09608c3c775e245c2728738a3efa1f29fff494802d6eb11d7f9ef286f06c"
    sha256 cellar: :any,                 sonoma:        "d07c5e4a281246f5d331072ca1be353148a17e80a02a8366b5c5c3be37e63de5"
    sha256 cellar: :any,                 ventura:       "040161bd62612f50541f438705e1781c929cdc464d932e2375fbec3f97c57fb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6e5f95a9cfa21ed944b810ab0065656731d1c7a1558dcfc3f177575b710c3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e33d6a79237c63f651832e9171a8bf8cac4c4e3d4b01b8a62530c7686ff8bf9"
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