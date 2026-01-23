class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30128/cdo-2.5.4.tar.gz"
  sha256 "c7fc17d3eda8c216edb2f5e36c8ab32bcaeeb6b6f16296246f065c576d4efad2"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfacd892a34ff89006c66cd1d0123591e82d5761afc98fdb96e29c840aa616de"
    sha256 cellar: :any,                 arm64_sequoia: "76ec5dc1b8b67ea28b5b9b5e9f3b04e9fcfcba4a092d69e5e972940b726607de"
    sha256 cellar: :any,                 arm64_sonoma:  "69959355e26fc581feb8a5a1983b6bd791bcff9b75aa286c28dc09e43e3ab280"
    sha256 cellar: :any,                 sonoma:        "fcd6ff17a782a62cf9b8028da2e0a4daaa22dc2e0db2b93fb94980625730a2ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f78e98e71248499b8627eeccfb880464d46b365ab5d6b5cf1bb617811f0be04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df7d4228b094933bb580f9d4872d255a566e909d1444b15af57085da541070b"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    args = %W[
      --disable-openmp
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
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