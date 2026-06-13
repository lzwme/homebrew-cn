class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/30212/cdi-2.6.2.tar.gz"
  sha256 "b882be222dc15253203526865ac444c2a9c6378e86afda7a48b6cca7b2a3cd7f"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aaf8dd6ae7646e2db75d20d5b1b65e2081db05eaaaf3dba06019cbb1fdff409e"
    sha256 cellar: :any, arm64_sequoia: "2e3432115afed3a529a6becc1d61e30f6a1d2881a76399dd0f49a8c39b712522"
    sha256 cellar: :any, arm64_sonoma:  "b8f7dfbfa8f2f108fbb69f5e1d2a1437d601d278b195158b001d5c5b0f7e59de"
    sha256 cellar: :any, sonoma:        "396532823c684e35b12bd892debdb195df96ad331bc9075660de2745276b1b5f"
    sha256 cellar: :any, arm64_linux:   "cd2012586460700d55b5d4c0fdc1d878e8d1009e05340df64db837a803ff37ae"
    sha256 cellar: :any, x86_64_linux:  "9e458721001ddb1d0983c51e7d8c49078c462522ea745dfa3a70d395771e3e63"
  end

  depends_on "eccodes"
  depends_on "libaec"
  depends_on "netcdf"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
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