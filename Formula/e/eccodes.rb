class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.37.0-Source.tar.gz"
  sha256 "26f2e4a43294e5199fd9a790a3af3bba327381711bbe142daf56eaf141efc4a1"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e9d99218e7d0715c970de28f4195c56d86c7bee493637a79f3548e12f259abcd"
    sha256 arm64_ventura:  "fadda872316900b0e84958a47b6168f88e46b53d172a9588a29a8a7bda97cc64"
    sha256 arm64_monterey: "954f7a6b86f29010c204fc97f17e7be65cf9c3aa54c613e59945bd38022d0cf9"
    sha256 sonoma:         "a1a6eb4de4d738a7365fad162dad671f5dddca2924edcda3dbc1b08022ab6226"
    sha256 ventura:        "8bddb1771d81dbd429765f5f0372239ab804a39424da5f839a060c365cbedaaf"
    sha256 monterey:       "2a0ab1bcd070bd16dfa5342ca065f6dfb93a181d5e421d2380bcc6dcfb7f2ee9"
    sha256 x86_64_linux:   "ad6560d9d8589589b3a0a38b1debf4ba7fd8a66eeef29e1f5f754291535b2162"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  def install
    args = %w[
      -DENABLE_NETCDF=ON
      -DENABLE_FORTRAN=ON
      -DENABLE_PNG=ON
      -DENABLE_JPG=ON
      -DENABLE_JPG_LIBOPENJPEG=ON
      -DENABLE_JPG_LIBJASPER=OFF
      -DENABLE_ECCODES_THREADS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end