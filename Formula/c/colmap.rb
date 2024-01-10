class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https:colmap.github.io"
  url "https:github.comcolmapcolmaparchiverefstags3.9.1.tar.gz"
  sha256 "f947ad80802baa8f00f30f26d316d8c608ab2626465eac1c81cf325d57879862"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0125e7dc58040883ee1ccc8f0a702ab2cc11533fbfc5c50906aa8252a8d9f978"
    sha256 cellar: :any,                 arm64_ventura:  "0947ae81496b2d5d52faa03b6871d42d7a876256c63fb4a77ed66d694aad66b5"
    sha256 cellar: :any,                 arm64_monterey: "71c9944d80b8b1900ba765831b5f8f1a885787c4c33507b6723aa916d52849df"
    sha256 cellar: :any,                 sonoma:         "9cf0469d8ed3ba7715eeb149c3e2cc0824aecbc66639f088f645df7fc1a2b4af"
    sha256 cellar: :any,                 ventura:        "91a562bc8f5c7cd52d7599a9cba01dc2ff75387b493eaaf69d8987b25d57223e"
    sha256 cellar: :any,                 monterey:       "2793fbb275fab4022f7b3f9bbf89cb3b40bd55ce8259ae7305301f48605cb281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1e42ea52ac4474c313d4a5f2c748fbb1452053b1a317c470c6a5ded5cedd10"
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
  depends_on "lz4"
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

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
    system "#{bin}colmap", "database_creator", "--database_path", (testpath  "db")
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