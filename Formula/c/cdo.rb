class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30213/cdo-2.6.2.tar.gz"
  sha256 "d59f57a3b33a063023b2b0ef8f38165e0bcf426d3b843031c5078e76832e957b"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "511e8f6de6a080cbf5a6bfabb9e1937f7e9fcfc79b39bc78fbbc9cf2283795ae"
    sha256 cellar: :any, arm64_sequoia: "78ba07d4cecf2a552ea96a050e6ac3c6860c9da9522a4c4415cb9b0a679a9ec6"
    sha256 cellar: :any, arm64_sonoma:  "e8c58b8c95859d8473c0ecf3cad8d7e59781ac17ccab902f00383545bdac74d4"
    sha256 cellar: :any, sonoma:        "bf520a35b60a24374dba4d0b0fa426823f8e0c81a64a30ce3e9ce9da5a638266"
    sha256 cellar: :any, arm64_linux:   "47f43c779e92d1a42d70ab22f8ae03ac16c29e5e132c085942c038c672561bba"
    sha256 cellar: :any, x86_64_linux:  "59dc7ce3668a303860b80cb66465191e96d821a388e7fd90e9b52bd3a769a0f2"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  def install
    args = %W[
      --disable-openmp
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-proj=#{Formula["proj"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    data = <<~EOF.unpack1("m")
      R1JJQgABvAEAABz/AAD/gAEBAABkAAAAAAEAAAoAAAAAAAAAAAAgAP8AABIACgB+9IBrbIABLrwA4JwTiBOIQAAAAAAAAXQIgAPEFI2rEBm9AACVLSuNtwvRALldqDul2GV1pw1CbXsdub2q9a/17Yi9o11DE0UFWwRjqsvH80wgS82o3UJ9rkitLcPgxJDVaO9No4XV6EWNPeUSSC7txHi7/aglVaO5uKKtwr2slV5DYejEoKOwpdirLXPIGUAWCya7ntil1amLu4PCtafNp5OpPafFqVWmxaQto72sMzGQJeUxcJkbqEWnOKM9pTOlTafdqPCoc6tAq0WqFarTq2i5M1NdRq2AHWzFpFWj1aJtmAOrhaJzox2nwKr4qQWofaggqz2rkHcog2htuI2YmOB9hZDIpxXA3ahdpzOnDarjqj2k0KlIqM2oyJsjjpODmGu1YtU6WHmNZ5uljcbVrduuOK1DrDWjGKM4pQCmfdVFprWbnVd7Vw1QY1s9VnNzvZiLmGucPZwVnM2bm5yFqb2cHdRQqs2hhZrrm1VGeEQgOduhjbWrqAWfzaANnZOdWJ0NnMWeJQA3Nzc3AAAAAA==
    EOF
    File.binwrite("test.grb", data)
    system bin/"cdo", "-f", "nc", "copy", "test.grb", "test.nc"
    assert_path_exists testpath/"test.nc"
  end
end