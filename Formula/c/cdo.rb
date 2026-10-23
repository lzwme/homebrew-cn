class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30251/cdo-2.6.6.tar.gz"
  sha256 "ed95f4ba9e5125e93a7c190185700e8cfb91da66991288a6d4a526e84d735f66"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "10a6eb0ba880d8b447ff07ff609ea0f6467889eaf942fc6bbe907462f83d4f0c"
    sha256 cellar: :any, arm64_tahoe:       "789c5d18ac91bd248d648ea8eb820901410a4766e56973f79a2ab3bc2faa0d0e"
    sha256 cellar: :any, arm64_sequoia:     "f7608ce4c9e231fd3398f38d9415a35a5a002346e4bedba00f2d57c9e7270714"
    sha256 cellar: :any, arm64_linux:       "499b3eedd6d7f08e1f4a9a211b9ecab790bcd32963aec5bf606530d9073bbec1"
    sha256 cellar: :any, x86_64_linux:      "052c0c9b6c4ab77107c18e1f59315d2bbe50e08b9dc0a25dcbb0a05050f3efcf"
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