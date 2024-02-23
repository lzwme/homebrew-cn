class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https:hfst.github.io"
  url "https:github.comhfsthfst-ospellreleasesdownloadv0.5.4hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32721921f2e226e15fd8fa796da4ea075b16fcc7af042ae6ca37aa7e2f19219d"
    sha256 cellar: :any,                 arm64_ventura:  "e9b8767edb7468e1b2bb2d1483f37613e4e491ed063e17e21d6315b7ae7507eb"
    sha256 cellar: :any,                 arm64_monterey: "ef9a63c4ae13d7d125e258b54ae95f1c63415265461591f346c5bce2584b7cf9"
    sha256 cellar: :any,                 sonoma:         "5b6261263768b7d11954b5e46836e34c43831ddd73be251297edebaae44af750"
    sha256 cellar: :any,                 ventura:        "cb66b9edfc5e299bdf24957ebeb959964db8b511a6aa3a34c53e6fce39076c0e"
    sha256 cellar: :any,                 monterey:       "dcf7f374aeced48efa67c0ba867db784a3938c83bcc692e24cd8771220a85336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25484f3abd7f9424adf9063f495ab6c3b005dfe89b0a4bb7d7c35401a0e8eb27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "autoreconf", "-fiv"
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}hfst-ospell", "--version"
  end
end