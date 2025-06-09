class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https:www.videolan.orgdeveloperslibdvdnav.html"
  license "GPL-2.0-or-later"

  stable do
    url "https:download.videolan.orgpubvideolanlibdvdread6.1.3libdvdread-6.1.3.tar.bz2"
    sha256 "ce35454997a208cbe50e91232f0e73fb1ac3471965813a13b8730a8f18a15369"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https:download.videolan.orgpubvideolanlibdvdread"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6aaf06a46650503ddadff95be7584a8fc86ee6e2d3c357475d26566cfda2b10c"
    sha256 cellar: :any,                 arm64_sonoma:   "6d2583d6d35a5b71d45cfbfc63e3e76dd9757c85973752b1583c4af9502d723c"
    sha256 cellar: :any,                 arm64_ventura:  "221b4cb3ad771cc650454a1624a89348973c3ef5bedc5f526b77e4bbb281b938"
    sha256 cellar: :any,                 arm64_monterey: "7c258b5c5be30d3ee53dacd0b137d7faadb5e21e06e5cf98859e7728e91cf303"
    sha256 cellar: :any,                 arm64_big_sur:  "e8642520b4bc06ac122e5c7e3affa0c80ed79678b09d220c1973e042aa11d30f"
    sha256 cellar: :any,                 sonoma:         "b1fa4f93b744c0b212e021aa63fa59f901e40b3ce029c11ea68f1e727698e1ea"
    sha256 cellar: :any,                 ventura:        "dbf236d4d32bb5e6d4180910f464225e5a09989d8fc542ec8bd5d3493a962308"
    sha256 cellar: :any,                 monterey:       "6ba400a8d928d2cd478969406000895023049c5a2257f11b6fab2791ff8b7105"
    sha256 cellar: :any,                 big_sur:        "cd57db884506fccb0b37b4cde83db05ba9cb15cddf1092f401918ae0972ac495"
    sha256 cellar: :any,                 catalina:       "5cd4a9df11e095e001d9d8a2a587f4701696de974b5527aea260afc9c5cc4f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82a35d755bc296bd802e404f47d1636732025171d577e9959b5b09f97d40b4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5805295785ab4ce6aeb1bdfeb7fe1aab4946ea9df2555f2016bbc540322f9c81"
  end

  head do
    url "https:code.videolan.orgvideolanlibdvdread.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", *std_configure_args
    system "make", "install"
  end
end