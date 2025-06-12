class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.1.tar.gz"
  sha256 "bb3f967a797c8851d08683ec43dfafe4ad7bf5ad86fa6b0721cad033ea9e5ae5"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c3e2054a2dd67178083adc389f3064f9a95b2900fea67eb5704b07a1a6eab3a"
    sha256 cellar: :any,                 arm64_sonoma:  "37f799a27326a3cd102eca875f98216eb21c662014de10a2999d0e817b95fbe1"
    sha256 cellar: :any,                 arm64_ventura: "81b9276d5115f95103b1f1563397a923453a4f8e67d04f174d5d8d0b583591cb"
    sha256 cellar: :any,                 sonoma:        "a1104e5eb72eed8da4d9420e7327c0d0a14855a7dd7904a5532fa8eb83d2e01d"
    sha256 cellar: :any,                 ventura:       "66fde48d8e084541a85f25dae1774af678046a3c9cbade8a2edcfbb9911d173b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac0be11f5111bd38f9ffc1c3974e052ba92d5d4d08c618bf31e97da5da8b8827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c563129e0f36262c3c138c659a4709991263e87bf7c38063f7d6b3fa751d6f5"
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