class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.32.1-Source.tar.gz"
  sha256 "ad2ac1bf36577b1d35c4a771b4d174a06f522a1e5ef6c1f5e53a795fb624863e"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "84fcfa3981352e9393a5b47922c3e13de42c01bd25fda4431d493fb76bc9c8f4"
    sha256 arm64_ventura:  "f23a85ef21e455ae8da7c47463af674d6e34e785e93a63f21f74e43369dc8220"
    sha256 arm64_monterey: "4bd94328795149b460210af77703d7cc7dd94801b386f76c0d5478c3ec554816"
    sha256 sonoma:         "40ac243a9fc46f8c4a301729e7152575cbaae5e639c090cf8cdf358d69b3238c"
    sha256 ventura:        "099306e197af195c93fe604a9540463a30c89134910033915eed8d045829ae7d"
    sha256 monterey:       "f9ac5195b1517781e6868d3591478c2be5ada213abbae3a6195b2d81eb9b5dc7"
    sha256 x86_64_linux:   "96f9149373f21cfe2e87cb8ba080f53b4b3f3e51238e55e5a8b2bdaac9be68b9"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON",
                            "-DENABLE_FORTRAN=ON",
                            "-DENABLE_PNG=ON",
                            "-DENABLE_JPG=ON",
                            "-DENABLE_JPG_LIBOPENJPEG=ON",
                            "-DENABLE_JPG_LIBJASPER=OFF",
                            "-DENABLE_PYTHON=OFF",
                            "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

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