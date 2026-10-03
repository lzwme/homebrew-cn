class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30247/cdo-2.6.5.tar.gz"
  sha256 "bbb58a519b463aa54477346794754a9936f2f09059a83fa9c82e76f1a13a5caf"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "58d9f0718fb58b004c6e9afa3dbca8a405e322f4e103020a6b37d688e41f5b4a"
    sha256 cellar: :any, arm64_tahoe:       "f74555cfc2674d925523ead33fac801a2ce1dfec5b7b04ddcd598a36db8beaf8"
    sha256 cellar: :any, arm64_sequoia:     "481c30209ae2f2b3781b9cae6a7207f5268386c3602d0409d0403b8042ee7b4d"
    sha256 cellar: :any, arm64_linux:       "e62b2c831c0cab90dedf870af5d27a6c4e87c4a10f4220ba136b153a20905291"
    sha256 cellar: :any, x86_64_linux:      "6880c3f2d320a2ad706c491b8adf33ebb57e1dc051e0749d1b2712c5d0e4c777"
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
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700 # for std::jthreads
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  deny_network_access!

  def install
    args = %W[
      --disable-openmp
      --with-eccodes=#{formula_opt_prefix("eccodes")}
      --with-netcdf=#{formula_opt_prefix("netcdf")}
      --with-hdf5=#{formula_opt_prefix("hdf5")}
      --with-proj=#{formula_opt_prefix("proj")}
      --with-szlib=#{formula_opt_prefix("libaec")}
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