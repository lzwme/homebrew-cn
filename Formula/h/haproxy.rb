class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.3.tar.gz"
  sha256 "0ea2d0e157cdd2aff3d600c2365dadf50e6a28c41d3e52dcced53ce10a66e532"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d49a2e9048a9deac178f37a9f84bc5e21afa4d85c8e235e81479ee8078440939"
    sha256 cellar: :any,                 arm64_sequoia: "1812447a90ff4efd8683e971645b72b678e0c2256e2eaa0b6770c833737ca0f0"
    sha256 cellar: :any,                 arm64_sonoma:  "ee4b0a25181fbbf8d331f9d9cb9019fab6a4089c815a907d66878830e4fac24e"
    sha256 cellar: :any,                 sonoma:        "fa271f38a7ddad16b407ae74a1b420c30aa52e3a77cde412f380243dfdc5d2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0873e8c9724ca0469ad97911a784a8df914be22930e24c96dd44c82fd4e210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92da095dd8ae77001d5652cad0755d5aaeef0bfca5137882093baa0d91d0cc74"
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