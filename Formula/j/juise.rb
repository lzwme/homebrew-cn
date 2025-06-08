class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https:github.comJuniperjuisewiki"
  url "https:github.comJuniperjuisereleasesdownload3.0.0juise-3.0.0.tar.gz"
  sha256 "54d641789bf9a531bc262876914e76888382522ad193eace132d16203546d51e"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "2013383bad9ecb913d1888a0cb957fa78044bf13aa30ba2a3bf52275d0009c49"
    sha256 arm64_sonoma:  "666efd51556692b16cd32582a0aacf68272c8f5c5bb4315e188f59f73bea6ca4"
    sha256 arm64_ventura: "a13e8825285d6e81d404b71bbced2b2e64b90074077c8862366c1f44acb8e409"
    sha256 sonoma:        "1e3b075c24e4fa37d85fbf1adee7d01520ae0bb37167e13f8d8369431292309f"
    sha256 ventura:       "0c88f52098999814254d35f3a82b7d61d40ab6dea598ff8924be683debc31c66"
  end

  head do
    url "https:github.comJuniperjuise.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libssh2" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libslax"

  def install
    system "sh", ".binsetup.sh" if build.head?

    # Prevent sandbox violation where juise's `make install` tries to
    # write to "usrlocalCellarlibslax0.20.1libslaxextensions"
    # Reported 5th May 2016: https:github.comJuniperjuiseissues34
    inreplace "configure",
      "SLAX_EXTDIR=\"`$SLAX_CONFIG --extdir | head -1`\"",
      "SLAX_EXTDIR=\"#{lib}slaxextensions\""

    system ".configure", "--enable-libedit", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "libjuice version #{version}", shell_output("#{bin}juise -V")
  end
end