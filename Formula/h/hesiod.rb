class Hesiod < Formula
  desc "Library for the simple string lookup service built on top of DNS"
  homepage "https://github.com/achernya/hesiod"
  url "https://ghfast.top/https://github.com/achernya/hesiod/archive/refs/tags/hesiod-3.2.1.tar.gz"
  sha256 "813ccb091ad15d516a323bb8c7693597eec2ef616f36b73a8db78ff0b856ad63"
  license "BSD-2-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b35e4acc79d9b6003e2358d0c508b8c0e8abd37b5668136f5b52ebdbec389bbc"
    sha256 cellar: :any,                 arm64_sonoma:   "4530f3f5f7f4402adcc86cd8a55a5427ce4c838b0193a126a0ddb21ef617e41c"
    sha256 cellar: :any,                 arm64_ventura:  "5eeb38db926fd0be3a2d565646b739000e20d3a9d556aadef81d6bd758c9255f"
    sha256 cellar: :any,                 arm64_monterey: "1887e1da4904dd97c1cb19c251cad52a79a8c83113075c65d7331ddff69cd99e"
    sha256 cellar: :any,                 arm64_big_sur:  "66f05bed0ecbd7328400f142a7864ec972fd3573d284375c222ff963a5ae7875"
    sha256 cellar: :any,                 sonoma:         "e84876e787316bb428e51e487e32bba65ad77323d34c4d2f3d1b72a0749e69ab"
    sha256 cellar: :any,                 ventura:        "7fe19d0020ba5289aa071273d00a86179fcadaf2d6352ccb6caf7bc213eb80dd"
    sha256 cellar: :any,                 monterey:       "d9006242a86ffc44a757bee9408f1e668cfc528ed9654816550b197118f73d7f"
    sha256 cellar: :any,                 big_sur:        "8b396dffcf3d833f50169ee20ae3ae126775cb40430ee4d2d967ba459834815a"
    sha256 cellar: :any,                 catalina:       "2e077b355ca0ed9f0bbadfc7b54ef681fc11f58c324ce19d3131fb61b99f15d2"
    sha256 cellar: :any,                 mojave:         "76748e285f22aed694c2933e4cd3a1469398ea254671755e6f89ad07e76b7f73"
    sha256 cellar: :any,                 high_sierra:    "de927a6526209db3673aa9e426d7e32f53b7a278798f07d6dc1c5069e816d09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "61a92d40669db1231ac941a5d2f4f71a09e9bad4907e36239dd22f9b71da305c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f798b02cd050763429e1db3c6e8afbb591bca678a8352fa8305cdbaa544a3f9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libidn"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hesinfo", "sipbtest", "passwd"
    system bin/"hesinfo", "sipbtest", "filsys"
  end
end