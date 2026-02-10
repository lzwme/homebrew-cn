class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://ghfast.top/https://github.com/pupnp/pupnp/releases/download/release-1.14.29/libupnp-1.14.29.tar.bz2"
  sha256 "021bc19c8fc42748bf65707ab091cfe63caa57ffabd3848f43c6dcf39e0bde1e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efc87565dd42da1cfc5d2155fcc2f34ed7c5395dcbeb6161635bc5e6f0e297d6"
    sha256 cellar: :any,                 arm64_sequoia: "b237cfa2e421ed3a9c9f493c71bc3ca3811476f19d2c49278123d31ee2ae65d7"
    sha256 cellar: :any,                 arm64_sonoma:  "03c9645a0b46c8b6cefccf7f1e31e638932ad4e1b85aa8f7abaa097ccff08d85"
    sha256 cellar: :any,                 sonoma:        "f9519a3fb69c574878b7343e50d08c7300f5de9e05c072632c9d3050d7facc38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97a119010d2d9d597d4dc76fb20c85c578752591458d4fc93f0f177879d9eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af81465ed7244683913f573be0ef981bdb09ebde4849322f0ab73e818351aa2"
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