class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.2.tar.gz"
  sha256 "7295cbc26cce19434494d54d9a810be8fdf3d35014b2ed3238bb4851a63792cb"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ed2d4101f405855020f3e15224e903976958ab42d302fc3a567113ed32d46b0"
    sha256 cellar: :any,                 arm64_sequoia: "e47cd19f58c3f552bcf24f2cfcd40dde90cc1d6dab6a1642c9256f7bec10c99e"
    sha256 cellar: :any,                 arm64_sonoma:  "39d8f248c9ce5ee0b230c1457fc11d54f3ad7bc6cffd35f120a844e9108c4c55"
    sha256 cellar: :any,                 sonoma:        "54f5a6a497604b488f54a4c9f5cd2f31875dedba1b11d55959ebbfe16648e0ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5810f105baca6dd6a3ca490cb511a200779d387098df66aabf7bff1c33db076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd9755ae56e83d0b9000a922c7e295e5603062e69f249f7040d1b75b7b8fd54a"
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