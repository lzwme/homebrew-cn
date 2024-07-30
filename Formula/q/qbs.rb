class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.4.0/qbs-src-2.4.0.tar.gz"
  sha256 "45ac69443222cd2d9e7a5ba01ee1962398996acbdd65a610c1e2118cad5270a6"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a01a3ad4235cfa3baf6b696de7cd2f49ee349a0ab3c9eaf927f5f1da2c7efda"
    sha256 cellar: :any,                 arm64_ventura:  "9566348eccda5f6c8a2796bb6871716c904f6dc50ff287f1bc6b2e95a6238b53"
    sha256 cellar: :any,                 arm64_monterey: "2f7a44a1bc8e17a82d030c3d41a0b2906efaa6ac8184b49f6bc5319abc2a1962"
    sha256 cellar: :any,                 sonoma:         "b0e8baf89f485582b137e06247fa74e025c69167073f6e2a8efb0279c15576ac"
    sha256 cellar: :any,                 ventura:        "59f190ef43b564101e41faa54d590954235a32b0f03378e6a3ccdb6395ed01ef"
    sha256 cellar: :any,                 monterey:       "4fed62972834894d013e0ba414ac87fa995b4c093e24c8a2661cac34abe75b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cffb0a5c9f4250fea7bf222426bc1b34a3bc769263389e9de577a46ac64914a"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
    qt = Formula["qt"].opt_prefix
    system "cmake", ".", "-DQt6_DIR=#{qt}/lib/cmake/Qt6", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end