class Oggz < Formula
  desc "Command-line tool for manipulating Ogg files"
  homepage "https:www.xiph.orgoggz"
  url "https:downloads.xiph.orgreleasesliboggzliboggz-1.1.1.tar.gz", using: :homebrew_curl
  mirror "https:ftp.osuosl.orgpubxiphreleasesliboggzliboggz-1.1.1.tar.gz"
  sha256 "6bafadb1e0a9ae4ac83304f38621a5621b8e8e32927889e65a98706d213d415a"
  license "BSD-3-Clause"

  livecheck do
    url "https:ftp.osuosl.orgpubxiphreleasesliboggz?C=M&O=D"
    regex(href=.*?liboggz[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3a4b600721b1878e170776c736e6813a9d38697c64e2685be45a1b1c24e88cc4"
    sha256 cellar: :any,                 arm64_sonoma:   "968d866fb1da405c4ac4b9d1b20b28d7323cf3dd1c4ce7062388db6c7cf3cf17"
    sha256 cellar: :any,                 arm64_ventura:  "2584e2cdadba3d9c788b756b2bf5d65277f99cc79645693ce437e6edb62c003d"
    sha256 cellar: :any,                 arm64_monterey: "2865f35c71995a85ca99d1efe73f8c1607da93ed30647113a744e1992d366a0b"
    sha256 cellar: :any,                 arm64_big_sur:  "286192f997ec0e02994b70cdc03d06d0616b10bea980b1aee7f3322f1d58735c"
    sha256 cellar: :any,                 sonoma:         "2dd95eaae16aeb758aaea166d463909c13c1a18734e4ad7eb93232894e5bd464"
    sha256 cellar: :any,                 ventura:        "500b41edf32a8bec24522f12651d2f876016e6199845e8791fbae1e309cd31ac"
    sha256 cellar: :any,                 monterey:       "83c7d4eb559e471b35ec7a615dbe11cbf35eaa82c510d44c4fbcd2eb0d41d8b4"
    sha256 cellar: :any,                 big_sur:        "e9f424566678f728990a41c130ae2682069b608d642aecdab827440fc56ef363"
    sha256 cellar: :any,                 catalina:       "6a107479a443028d27afcfa51b68899449120637dcbe8e6987ce0e5191b1ee59"
    sha256 cellar: :any,                 mojave:         "21ee59402b2854a91629c96c0e3540a1e97e9661984800d4d80d650069fcf0be"
    sha256 cellar: :any,                 high_sierra:    "f444304f94866179ffcbe6322d6f25193b4fcd2dc49ad71f9c9527b0d85934de"
    sha256 cellar: :any,                 sierra:         "a0fad22ba18930be45c7226f2db0fe8b39c988c84c392807ddc75e2d40b3a9ad"
    sha256 cellar: :any,                 el_capitan:     "4c1819dbc134981faf5e2e03dc69d210deb8dabd59b71969c1f479fa32322635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32cc66ca90d54de30392f5c92d7858fd3cb86068a7363ed869aece87f0f9bb1"
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"oggz", "known-codecs"
  end
end