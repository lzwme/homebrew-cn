class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29020/cdi-2.3.0.tar.gz"
  sha256 "fff47c8eac38ec2e0f47715aadcbc1343b166aa017f0466019e73c4a53a323a6"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ae2c90cfa070057b4edc714f3ddde24bf5aa455a81b2b998634c855fa62caae"
    sha256 cellar: :any,                 arm64_ventura:  "e0d5baef97f109bfa43ef317d528050b3d70c52de0fa702d1aaede31bc1e659a"
    sha256 cellar: :any,                 arm64_monterey: "addc58d5737d12ff8a30d1ce3f342d93f07b0b25198185f08aa04b2f5c50b7b1"
    sha256 cellar: :any,                 sonoma:         "da0376631baec0ad089466c06d733285f12ad7ab7bba6ba65d64b27ef2273cd5"
    sha256 cellar: :any,                 ventura:        "84c7fc168b237c297989d2bbd523633868d64f79ebdd9f6d3c303e42f6a748e7"
    sha256 cellar: :any,                 monterey:       "92296e036796c3661a7912991e7d2da960707a3ca790b505bd125d70298c301f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d96530868c99b7e706281ebb6477f23ce026928ce4947134af81fa12bb3e65"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

  def install
    args = %W[
      --disable-silent-rules
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
      #include <cdi.h>
      int main() {
        // Print CDI version
        cdiPrintVersion();

        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcdi", "-o", "test"
    assert_match "CDI library version : #{version}", shell_output("./test")
  end
end