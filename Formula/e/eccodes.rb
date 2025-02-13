class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.40.0-Source.tar.gz"
  sha256 "f58d5d7390fce86c62b26d76b9bc3c4d7d9a6cf2e5f8145d1d598089195e51ff"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "63b3435ed34b7af5856f4b9c57cdaa4c23f47749ad2aa665f01a97f28fcc5da6"
    sha256 arm64_sonoma:  "81fd4655d539acaaa54ddf83dc3e9fcd8a2a191b7a2e410f6020339758710405"
    sha256 arm64_ventura: "ecbbf575d50dbfd68c0799c751ea2358d9a684072efb8e29381d564629277e11"
    sha256 sonoma:        "5b1ab49dfec9188ff63644aebc3521abb7cc2a188134c199944631fad2b8699d"
    sha256 ventura:       "4f91cd88bb054dbbbe92d97eb2fbf58d0696b6c62f8b584d9352e6013ea0932f"
    sha256 x86_64_linux:  "2e1fc7f9b7cc5ee2ed26138b81d8ca9b1b768dc3e096013dcc22bab40c2065fd"
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