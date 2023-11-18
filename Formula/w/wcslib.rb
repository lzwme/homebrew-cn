class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/people/mcalabre/WCS/wcslib-8.2.1.tar.bz2"
  sha256 "b666c79568fc0cf16b6d585ff3d560ae5e472c3b1125a90ccc8038f8e84aca19"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a6a735f5f5208fd4cc1a5516f99be3db8390d5af1e88b3ffef1b29259abfa0f"
    sha256 cellar: :any,                 arm64_ventura:  "c17859ef90d2865795a30212e9e434440a1b52c44b1821cb643d88085a801b6c"
    sha256 cellar: :any,                 arm64_monterey: "6c0b5e3a38fbc846032653ec8cfedb68b8605880f3481c6aa99ed166085e9e9c"
    sha256 cellar: :any,                 sonoma:         "6f78345cf931cdc0fc60a6aaac9a16f24b017e4ffb200e08b2898a676c3aae6a"
    sha256 cellar: :any,                 ventura:        "dbccacee83ba1d5fc272c2008a5fe43af29e4d183bab71da0026b634346a5667"
    sha256 cellar: :any,                 monterey:       "a81d20dfb11ea07fea0537ac74d30655844f539898bbf98c0dc5557d35cd4f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f08520d87eea4e3236716ba210761a55b047862b4c5d4aecf537138a79e0c10f"
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end