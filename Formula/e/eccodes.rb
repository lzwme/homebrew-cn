class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.49.0-Source.tar.gz"
  sha256 "ef5566475f017e5fe6c6c794907f0a2cf2fccbf20c34b25a4ba4529e5dc48226"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "00fe6961d70465221c29988e900e1c3fe11ab797378a7f6daf6b9557a0c3a054"
    sha256 arm64_tahoe:       "5605082bd7bb8888472fc17d5743ceb111384e1033ca0d7a60d4ea0615aed115"
    sha256 arm64_sequoia:     "9987ab7fb082064625cc5fed0d181ae6586e3527929657f58a10301db34c4b4a"
    sha256 arm64_linux:       "93e9ea87a1bf683747ca984834acb02c426082742852823ca6e94b6a4fd13386"
    sha256 x86_64_linux:      "ffecde5a1352d6bf2c868770bcb51c66605db662d35d1728076c957c4e316fac"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  deny_network_access!

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