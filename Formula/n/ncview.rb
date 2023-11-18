class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "https://cirrus.ucsd.edu/~pierce/ncview/ncview-2.1.9.tar.gz"
  sha256 "e2317ac094af62f0adcf68421d70658209436aae344640959ec8975a645891af"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af171a4892c6b90795a73587b8bae4609b3d4557069429fb4164248af6652e23"
    sha256 cellar: :any,                 arm64_ventura:  "4106c83043737511d917bc3a0ec58550755105da4bba9529a5255261b20509f8"
    sha256 cellar: :any,                 arm64_monterey: "4b9a2fe5e122904730f56fd97a17546c2e7fe0de5ac9e9ecf9390c55d01becc1"
    sha256 cellar: :any,                 sonoma:         "3b036009d0945491ca402bc423774c67d65b2b0aea1cb15898eafbb34a8fdf7c"
    sha256 cellar: :any,                 ventura:        "33672f8eff48b909beca62e2552c72815ed2cd283dcdc95685fc29e6d7cd01e2"
    sha256 cellar: :any,                 monterey:       "2b7c119ee0ac4738afa52f5389c2bce3c385c05d2f68e3cbc4c4304475050cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb2f05e3e8e25c53938edf7737d84a53e01923531bd390d9c0823d016fa28bd"
  end

  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "netcdf"
  depends_on "udunits"

  on_linux do
    depends_on "libxext"
  end

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("DISPLAY= #{bin}/ncview -c 2>&1", 1)
  end
end