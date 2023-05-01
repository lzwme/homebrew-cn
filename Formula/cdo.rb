class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/28013/cdo-2.2.0.tar.gz"
  sha256 "679c8d105706caffcba0960ec5ddc4a1332c1b40c52f82c3937356999d8fadf2"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20162b0625ba6ec314f64511586b5ac4502eebe20af65d3746a783af3a8e3f87"
    sha256 cellar: :any,                 arm64_monterey: "3238106233ae18f4761af3bc0d97df1204dd67a14995cc51e6fa28a66bc37163"
    sha256 cellar: :any,                 arm64_big_sur:  "399f9cf09c579851a78c1f9c3f66d6faf631e64c6ea10eb961393603b880b2e7"
    sha256 cellar: :any,                 ventura:        "dc8ac8f975678860ef3c04f28b438e0e7a94229ebecc8eac164037b3c92c9985"
    sha256 cellar: :any,                 monterey:       "e0617e37277bc7d52393a58bf8fc53b1875cc12079c1face98ed3ef7a178f341"
    sha256 cellar: :any,                 big_sur:        "fac96f4a690114fc3b7f622be7ed7e594baf0aae6b34110b19b3fdccf2a3413f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ce2ecf4cfc566ab116a592ca46168ab602e27fc0c10d215b7577ab1d69dd20"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    data = <<~EOF.unpack1("m")
      R1JJQgABvAEAABz/AAD/gAEBAABkAAAAAAEAAAoAAAAAAAAAAAAgAP8AABIACgB+9IBrbIABLrwA4JwTiBOIQAAAAAAAAXQIgAPEFI2rEBm9AACVLSuNtwvRALldqDul2GV1pw1CbXsdub2q9a/17Yi9o11DE0UFWwRjqsvH80wgS82o3UJ9rkitLcPgxJDVaO9No4XV6EWNPeUSSC7txHi7/aglVaO5uKKtwr2slV5DYejEoKOwpdirLXPIGUAWCya7ntil1amLu4PCtafNp5OpPafFqVWmxaQto72sMzGQJeUxcJkbqEWnOKM9pTOlTafdqPCoc6tAq0WqFarTq2i5M1NdRq2AHWzFpFWj1aJtmAOrhaJzox2nwKr4qQWofaggqz2rkHcog2htuI2YmOB9hZDIpxXA3ahdpzOnDarjqj2k0KlIqM2oyJsjjpODmGu1YtU6WHmNZ5uljcbVrduuOK1DrDWjGKM4pQCmfdVFprWbnVd7Vw1QY1s9VnNzvZiLmGucPZwVnM2bm5yFqb2cHdRQqs2hhZrrm1VGeEQgOduhjbWrqAWfzaANnZOdWJ0NnMWeJQA3Nzc3AAAAAA==
    EOF
    File.binwrite("test.grb", data)
    system "#{bin}/cdo", "-f", "nc", "copy", "test.grb", "test.nc"
    assert_predicate testpath/"test.nc", :exist?
  end
end