class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-1.14.26/libupnp-1.14.26.tar.bz2"
  sha256 "80a4ea3608fff10a30448c8a87477063d5fc62c981c24a21edd40c2ecdab323c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "534eb6e293556d55c840a88bd08cbf14d7df38430504dd2571e981a400bde132"
    sha256 cellar: :any,                 arm64_sequoia: "888e22bf332f03a019db1a54f2547f931770bf24b95aa46fa6bd1f6cfbab48aa"
    sha256 cellar: :any,                 arm64_sonoma:  "e8b919a9f11dbefb6d7d40ba578b6d648aaa125c351c167e9695a89050f8c2d8"
    sha256 cellar: :any,                 sonoma:        "9d09f5662db6f6895cbccc9d1dce2c2b23895a9552d633081cb31696fac180c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06917e5a2deb13ecd4b490e5e8c32da831bbe411b702573044df1f1b83511424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a9bab99264be3ac7a20ee9962bea9edca47f2a3c7c3dd6223d58413b5820cf"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end