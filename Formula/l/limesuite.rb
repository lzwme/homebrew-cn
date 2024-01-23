class Limesuite < Formula
  desc "Device drivers utilities, and interface layers for LimeSDR"
  homepage "https:myriadrf.orgprojectssoftwarelime-suite"
  url "https:github.commyriadrfLimeSuitearchiverefstagsv23.10.0.tar.gz"
  sha256 "3fcbc4a777e61c92d185e09f15c251e52c694f13ff3df110badc4ed36dc58b00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7fa221daaba6f38b5547ac3d6a926e71a0b2a030f1904047ec465d57734ec542"
    sha256 cellar: :any,                 arm64_ventura:  "d18b801940cfdd3c688fa025ab7a07aebf82ba797616564fa0801b64dabc7669"
    sha256 cellar: :any,                 arm64_monterey: "c9f953eb1aeecf1e9b6b7c12460d76c54310aea3623bb469fc285d04b159ec03"
    sha256 cellar: :any,                 sonoma:         "6f61409f1331a7cf8fdcdeb66bc4dad8764b5d60b3e10a3709d58d897f591ead"
    sha256 cellar: :any,                 ventura:        "3056a953802faacfd27085dee1cf178d251218601472403cf93679ce50d20987"
    sha256 cellar: :any,                 monterey:       "dc247d9cf6a138821854f8c8fbf95bc1288d1d77ca1d36d534c19e67366c12f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2db9cdd66f642de1423da2d5b486371a1d9c1d8dc988facbe8edb06a2dbd1689"
  end

  depends_on "cmake" => :build
  depends_on "fltk"
  depends_on "gnuplot"
  depends_on "libusb"
  depends_on "soapysdr"
  uses_from_macos "sqlite"

  def install
    args = %W[
      -DENABLE_OCTAVE=OFF
      -DENABLE_SOAPY_LMS7=ON
      -DENABLE_STREAM=ON
      -DENABLE_GUI=ON
      -DENABLE_DESKTOP=ON
      -DENABLE_LIME_UTIL=ON
      -DENABLE_QUICKTEST=ON
      -DENABLE_NOVENARF7=ON
      -DENABLE_MCU_TESTBENCH=OFF
      -DENABLE_API_DOXYGEN=OFF
      -DDOWNLOAD_IMAGES=TRUE
      -DLIME_SUITE_EXTVER=release
      -DLIME_SUITE_ROOT='#{HOMEBREW_PREFIX}'
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Checking driver 'lime'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}SoapySDRUtil --check=lime")
  end
end