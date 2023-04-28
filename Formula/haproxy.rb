class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.7.tar.gz"
  sha256 "d0f89cb3244fc7bd93b6a6e9aabfc564f21386867288b5dd93160913e6cc4b89"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "237b76447e8d85c7f353c9edae0e0e46d27d859d375908ca04d9400d0e45dc4a"
    sha256 cellar: :any,                 arm64_monterey: "86c07f6a715403a1bbd97b7b513f310e2cd6d6eef93fb98b70763a4f25030010"
    sha256 cellar: :any,                 arm64_big_sur:  "48cc55206810b662fbfcba1e80b55f993102caf602acc6f325702328be31ec1a"
    sha256 cellar: :any,                 ventura:        "c2dcc670306dc6e555cac9b74f412c33000aa68a419cea55e70ec23b4e9ff2aa"
    sha256 cellar: :any,                 monterey:       "e9ee0177de320c6b4f66c3af97e9c9060fd72bb26acf4c50b3f442d7e89afc5f"
    sha256 cellar: :any,                 big_sur:        "0d2e6323ffcb252ac854e79823e860bd738028123c5264d5d465be8c05933b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969783af1e8f0d2cfc8a2f03a5d0fa65f032353ea247536d40ea7ce57677bf09"
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