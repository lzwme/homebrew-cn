class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https:colmap.github.io"
  url "https:github.comcolmapcolmaparchiverefstags3.10.tar.gz"
  sha256 "61850f323e201ab6a1abbfb0e4a8b3ba1c4cedbf55e0a5716bdea1df8ae1813a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e66ed8897969562e2f7f1064904a1378ba1215d0496e73b879af43f77f50455"
    sha256 cellar: :any,                 arm64_ventura:  "59b95f21f9a19a6d300ccd8732d4c2fbccae6b516efa9ef2512f1268c7cbe792"
    sha256 cellar: :any,                 arm64_monterey: "a398f35d16d695514364a838157b3e675d01a6093ace52a6e084c7b3e5bb79b0"
    sha256 cellar: :any,                 sonoma:         "7b5d4f750563fa282bdf0e51896696d86c438d58e57cb1c9ae8946227fc36245"
    sha256 cellar: :any,                 ventura:        "f34cbcfe17fff0582a91d9b6f8a7c295fa64a65a63919e322ebdea82ec79825f"
    sha256 cellar: :any,                 monterey:       "67d6f2823721734595ddb680d50ee2d14a1952b7d4dfe778f282dfaad366a59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a87578e228dc96603dc715fda37f342be6b94bda5095dfa47d6b271c7df19c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  # Remove this patch after https:github.comcolmapcolmappull2338 is included in
  # a future release
  patch :DATA

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    system "cmake", "-S", ".", "-B", "build", "-DCUDA_ENABLED=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"colmap", "database_creator", "--database_path", (testpath  "db")
    assert_path_exists (testpath  "db")
  end
end

__END__
diff --git asrccolmapimageline.cc bsrccolmapimageline.cc
index 3637c3dc..33fff7da 100644
--- asrccolmapimageline.cc
+++ bsrccolmapimageline.cc
@@ -27,6 +27,8 @@
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
 
+#include <memory>
+
 #include "colmapimageline.h"
 
 #include "colmaputillogging.h"
diff --git asrccolmapmvsworkspace.h bsrccolmapmvsworkspace.h
index 73d21b78..6d2c862c 100644
--- asrccolmapmvsworkspace.h
+++ bsrccolmapmvsworkspace.h
@@ -29,6 +29,8 @@
 
 #pragma once
 
+#include <memory>
+
 #include "colmapmvsconsistency_graph.h"
 #include "colmapmvsdepth_map.h"
 #include "colmapmvsmodel.h"