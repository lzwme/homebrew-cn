class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29833/cdi-2.5.0.tar.gz"
  sha256 "19654af187d8b29e708b1c7e4726143cf26547966dceba8cc5b68690281ddad9"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9384cb54ff1da2c04928284bda73501795e0fb8b296e583fdfb9fc29c2ddae9"
    sha256 cellar: :any,                 arm64_sonoma:  "c08d7982373c7bc94e1a7252d715f8a1369d6ed0be7cda29fcb96f638d2777f2"
    sha256 cellar: :any,                 arm64_ventura: "3ad05327085edbc43f76e6e7f801548b032f63ee8acbd683a0c700a5c8f92eca"
    sha256 cellar: :any,                 sonoma:        "dd18385eb9c2e36f0c722c31dcd3facf9947694da7a1a72e3245e90368cef2f6"
    sha256 cellar: :any,                 ventura:       "88c6a19964183954695a733c9bcc583b6597eb9a38f1590c5bcaceb19f5c6617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd8ce8bcea57dd2460252dbc8920bf20703b8c64f69d488c7292f35a31513ce"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "util-linux"
  end

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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cdi.h>
      int main() {
        // Print CDI version
        cdiPrintVersion();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcdi", "-o", "test"
    assert_match "CDI library version : #{version}", shell_output("./test")
  end
end