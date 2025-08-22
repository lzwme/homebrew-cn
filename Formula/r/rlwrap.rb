class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://ghfast.top/https://github.com/hanslub42/rlwrap/archive/refs/tags/v0.47.tar.gz"
  sha256 "07cd1c52aee96c05bf0db4ed8da63e854f07a1ca134b21b73c5d5d1969b337b5"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "2a59e6a0fe135e477c356e6d665c372a62f07eb5a3ac6d24c617debfe18e9981"
    sha256 arm64_sonoma:  "da6c4a73ea0dfd9342e655646b61459f377b276e2ccafc44c95fa46ecbe25857"
    sha256 arm64_ventura: "b4d39e973a509309a2ae1fe601d08b6724f39cedb234af8c2d8e71fce05806c9"
    sha256 sonoma:        "900fe4432c04c11692a3ffbb6a028da1be8cace30fb6bbe66737095e2aeae36f"
    sha256 ventura:       "da2834817e7764c22490aad42916b266be3f4bf9a00d5ed0496316048077ab56"
    sha256 arm64_linux:   "2c116929ab6de8dc324247a589c14f9b8b2bdec38e254b46f37bae1372fa955c"
    sha256 x86_64_linux:  "ac4addf173ac475644acee5a26104e74c72d72585278f35f886638222d22733b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    # TODO: add `libptytty` as a formula, there is a fallback for now
    system "./configure", "--without-libptytty", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rlwrap", "--version"
  end
end