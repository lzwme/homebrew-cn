class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/28653/cdo-2.2.1.tar.gz"
  sha256 "136801db175daeffb39065f8becbb1831944949bfc1872ead6bc5bfd5aa839e5"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a902b85aef70253c41b0f4b196a53dd6c4a3820916ddfb8d0b64130839d67d8c"
    sha256 cellar: :any,                 arm64_monterey: "7450c990b6846c9f775fb44e4a6cdf5f0a9bd2f4b022c1f7db9dc1999a3d8e3a"
    sha256 cellar: :any,                 arm64_big_sur:  "6b2ab628ed449dc9e1ddd7dc01cf9338e378ae8be08b5465d0379cf423d5cf59"
    sha256 cellar: :any,                 ventura:        "10dc982b1bac549fd954b590af08ce8f3bf58b1dd81ba1a1ff7ed5bfc6c0c9b0"
    sha256 cellar: :any,                 monterey:       "8b1cb0d8dbb97ad29e24fda86f8da9ec51d074a42a0ce4b2e9e7593e57f81aa3"
    sha256 cellar: :any,                 big_sur:        "123a7848be33851a5eba05c8ed79a2758d78fa2ef814d8c27052dd55143027d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7f006e913e4de4f732a2f2132ec51bf7f27db39174911b6b98448ef3e760aa"
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