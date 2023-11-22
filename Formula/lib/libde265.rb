class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://ghproxy.com/https://github.com/strukturag/libde265/releases/download/v1.0.13/libde265-1.0.13.tar.gz"
  sha256 "b921bc90521f28914bbf0c638c436b79831857ca4f7af1f3dd4ce2228bf40cfd"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b7c967d90b15aea2f9ff1fa55933cbc78f59d4c6ad048a1bf443d9cdf029850"
    sha256 cellar: :any,                 arm64_ventura:  "c525955fce8a2ed32a39b0e2a8ebd6961111bd1837669d322cf625fe7063f0a6"
    sha256 cellar: :any,                 arm64_monterey: "cacf5339101cbb767f8549f62360f1e3d77dbf35d10793da87243b3f1ec4d7ac"
    sha256 cellar: :any,                 sonoma:         "6180cb068129c00d34a6740c5561a589b4543bffa113e01cc7d4f77e9a66dccd"
    sha256 cellar: :any,                 ventura:        "87de0283611f30ad3ea12ca5558dd2e20ef90aede0be5be12dcd289e14d99ca4"
    sha256 cellar: :any,                 monterey:       "bfd850c89bc435c78ff94b9dbdb68207da4c8bfa693dbc83d03d04055fba3eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9dc81c47c1b18dae592dc4e380bbf5a8edfaf226d3aee0a90a668c4f36035c2"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    extra_args = []
    extra_args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if OS.mac? && Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sherlock265",
                          "--disable-dec265",
                          "--prefix=#{prefix}",
                          *extra_args
    system "make", "install"

    # Install the test-related executables in libexec.
    (libexec/"bin").install bin/"acceleration_speed",
                            bin/"block-rate-estim",
                            bin/"tests"
  end

  test do
    system libexec/"bin/tests"
  end
end