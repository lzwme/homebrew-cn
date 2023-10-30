class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://ghproxy.com/https://github.com/willbryant/kitchen_sync/archive/refs/tags/v2.19.tar.gz"
  sha256 "ca9373afb2e532c50ba9106f0c3923811694cb72334ea14162c4d128bdc2e91d"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e981419d14a99200a80cc6581e643745f6ae9be9255968289e13eae5da8f3dfb"
    sha256 cellar: :any,                 arm64_ventura:  "85519df52705a3a53b33c488849e09cab5c09b7c20e5f55aa373cc991e6fd398"
    sha256 cellar: :any,                 arm64_monterey: "b30703e668e9751c85b607ac8c3bc70ea8ddf6556803829efebe9db994303f9b"
    sha256 cellar: :any,                 sonoma:         "c7c4e795a0b3f8c38b1c6a9c1f1d3e2cb59d4a0284fc1eed76427e6d98aed49e"
    sha256 cellar: :any,                 ventura:        "e8687c91c06343b396f66bbdb772c0e79cf62f3ee03f7325761e213650cfc2ae"
    sha256 cellar: :any,                 monterey:       "d56833a49416c7cdce5ecf74a23fa0cf70128fc73d7e35318843ba5763cb647c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7763cd06e88174e11b8c6bf21e2d3e5a4c8a3df405e5e1842555773815f99bbc"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  fails_with gcc: "5"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end