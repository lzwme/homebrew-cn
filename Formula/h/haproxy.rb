class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.1.tar.gz"
  sha256 "fef923c51ddc0ffb3c73b9b95e31e98c82cb9521c64754c5e95c42907406a670"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "56e148019a28b7f58dddc1231744039a207f1049de2eb1809e9431191578a73f"
    sha256 cellar: :any,                 arm64_ventura:  "f35fc0ab59bf8fecaf6c7548337f646f69661ba9a32883657e75ffc97c243ffe"
    sha256 cellar: :any,                 arm64_monterey: "f6927125bc2c3afbfc4da050f64012b38450e23b6c14ffbc9dd081384ef580bf"
    sha256 cellar: :any,                 sonoma:         "66035912d51957036306ae56cea3f41cd5d5a449f3dac25efcd2f5f4ed68bb4e"
    sha256 cellar: :any,                 ventura:        "1fa3f0fa97b3ea3dd42a81d40696a0468fd53c04f754dc3b364232a65b8e8894"
    sha256 cellar: :any,                 monterey:       "54672c3334fcb83b24fb31c1d80dc9bbff2f4e198e637838a378608b0e1ef373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c28baf508f01593cbec60c6573c917f1eea70651fb707c329544173ed05775bb"
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