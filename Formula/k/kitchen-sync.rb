class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https:github.comwillbryantkitchen_sync"
  url "https:github.comwillbryantkitchen_syncarchiverefstagsv2.20.tar.gz"
  sha256 "e79e5dfad48b8345b1d80444a0e992b2f9b9c53f29f6f607647e567292a7d0f2"
  license "MIT"
  head "https:github.comwillbryantkitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9821f09b7f11d7dabec107ae7bb120ff7711721149cffe458e0e1efc976e58f"
    sha256 cellar: :any,                 arm64_ventura:  "52da1db89b0c2d36ee37651f789c9544fcb9e598464e4c141098cac805cce66d"
    sha256 cellar: :any,                 arm64_monterey: "68405e9bce21249e1cd3a7edb2c166b9322851858ec84c2de9147309eb7f6156"
    sha256 cellar: :any,                 sonoma:         "8a33caa241b8a4402c0c70c2e328e85f20ddf347679b2ef3432e1a4a917a2c47"
    sha256 cellar: :any,                 ventura:        "f43ba4ad13d25b2625a8f186a1e5b929467c6d17bf597e0557d95d9cad20fbaa"
    sha256 cellar: :any,                 monterey:       "7c95652e20014ae659264af72721db5e6ad1e9c2eec1b7eac286d3ee1e79f2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127c662bc3b1f282cefe2e883e8d28727d6ba136eecddb3bc9266f7a756e6915"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  fails_with gcc: "5"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}ks --from mysql:b --to mysql:d 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end