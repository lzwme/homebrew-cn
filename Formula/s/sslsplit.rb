class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/droe/sslsplit.git", branch: "develop"

  stable do
    url "https://ghproxy.com/https://github.com/droe/sslsplit/archive/0.5.5.tar.gz"
    sha256 "3a6b9caa3552c9139ea5c9841d4bf24d47764f14b1b04b7aae7fa2697641080b"

    # Patch to add `openssl@3` support
    patch do
      url "https://github.com/droe/sslsplit/commit/e17de8454a65d2b9ba432856971405dfcf1e7522.patch?full_index=1"
      sha256 "88d558dcb21b1a23fe0b97f41251e7a321b11c37afd70dd07ac1a2d6a4788629"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad6eef71652050dd7586ca130538d612f71d6e0486a5c1b2b9eb98e5d0675e0c"
    sha256 cellar: :any,                 arm64_monterey: "dba0a5403a541ff22b1e63577de39af59c2bdfa4ea43536664526efd4c10b479"
    sha256 cellar: :any,                 arm64_big_sur:  "9a6bc8259feb162971310ab7cbb802a6d792c9a13684d756c74f2e4c12f91527"
    sha256 cellar: :any,                 ventura:        "6b5c5082caa1b33a2ec68d438965ef1c405404b8808ca1fd9cda7397ac366165"
    sha256 cellar: :any,                 monterey:       "5f23f06acb83de8e1730a267b0e543e5a2b46af6ca0021922fa2e427c8eb3cdb"
    sha256 cellar: :any,                 big_sur:        "5609fe01116b26aeae02e483354ab84a4b9cb223095618640c32af5bd7341cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e62ef71e9d154f54fac451123377ad0c59d103b544386b4100ecb34da2ad2cc"
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@3"

  def install
    ENV["LIBNET_BASE"] = Formula["libnet"].opt_prefix
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port

    cmd = "#{bin}/sslsplit -D http 0.0.0.0 #{port} www.roe.ch 80"
    output = pipe_output("(#{cmd} & PID=$! && sleep 3 ; kill $PID) 2>&1")
    assert_match "Starting main event loop", output
  end
end