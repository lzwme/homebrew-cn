class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.22.tar.gz"
  sha256 "cec5cf0b8b1006239407eea15080e380f24a953a1394e9b0e0cbbc956ebcbc67"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e41082612f06bc7dbebc6a32299eb309a70834ebae99b11c249cff314fcaa73f"
    sha256 cellar: :any,                 arm64_sequoia: "e0e00e866139668fd5a6d7a9b9545b14c14c3ae6545fd01ae0e85cb0eaa03e26"
    sha256 cellar: :any,                 arm64_sonoma:  "a45f6da42585374514ebfa22fecb3a5cbc100c1f28eac19bd287114775089161"
    sha256 cellar: :any,                 sonoma:        "c56cf7ac031454ed282ad479b8cea5771bd0a9da1cd9ec4d64bf6ef3980813c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4e908b810cded30216bfe94dea3dd9f86dbf438c794a065205711f1f7705c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1c1fd7a4d438182c1ad570406f54bfb9f90b8cb7a094a85d2672dca7a41b9e"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

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