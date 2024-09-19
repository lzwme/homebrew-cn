class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https:www.mlpack.org"
  url "https:mlpack.orgfilesmlpack-4.5.0.tar.gz"
  sha256 "aab70aee10c134ef3fe568843fe4b3bb5e8901af30ea666f57462ad950682317"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https:github.commlpackmlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "9ca50b03e3db7e2817622163e1dce672ab01b9ddf34b50787cc8bd64b8c8e4c1"
    sha256 cellar: :any,                 arm64_ventura: "2795f327b550595741bd54399e52576fc7cfbc46c5da3340da1953175e011220"
    sha256 cellar: :any,                 sonoma:        "47f26da6cb96287945833af56b0e990a8d938aefbb75317e04d6bbd6a5a91ce0"
    sha256 cellar: :any,                 ventura:       "ed7ce8c89e9d22da8bdc0393c04ff52591a675c666923dfcb7abcb2974d69d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef590cec6b87dd20bd0a40f945c9ff841b94cc49578560aa578975c27e7d686c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  depends_on "armadillo"
  depends_on "boost"
  depends_on "cereal"
  depends_on "ensmallen"
  depends_on "graphviz"

  resource "stb_image" do
    url "https:raw.githubusercontent.comnothingsstb0bc88af4de5fb022db643c2d8e549a0927749354stb_image.h"
    version "2.29"
    sha256 "c54b15a689e6a1f32c75e2ec23afa442e3e0e37e894b73c1974d08679b20dd5c"
  end

  resource "stb_image_write" do
    url "https:raw.githubusercontent.comnothingsstb1ee679cstb_image_write.h"
    version "1.16"
    sha256 "cbd5f0ad7a9cf4468affb36354a1d2338034f2c12473cf1a8e32053cb6914a05"
  end

  def install
    resources.each do |r|
      r.stage do
        (include"stb").install "#{r.name}.h"
      end
    end

    args = %W[
      -DDEBUG=OFF
      -DPROFILE=OFF
      -DBUILD_TESTS=OFF
      -DUSE_OPENMP=OFF
      -DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}
      -DENSMALLEN_INCLUDE_DIR=#{Formula["ensmallen"].opt_include}
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_libshared_library("libarmadillo")}
      -DSTB_IMAGE_INCLUDE_DIR=#{include"stb"}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc*"]
    (pkgshare"tests").install "srcmlpacktestsdata" # Includes test data.
  end

  test do
    system bin"mlpack_knn",
      "-r", "#{pkgshare}testsdataGroupLensSmall.csv",
      "-n", "neighbors.csv",
      "-d", "distances.csv",
      "-k", "5", "-v"

    (testpath"test.cpp").write <<-EOS
      #include <mlpackcore.hpp>

      using namespace mlpack;

      int main(int argc, char** argv) {
        Log::Debug << "Compiled with debugging symbols." << std::endl;
        Log::Info << "Some test informational output." << std::endl;
        Log::Warn << "A false alarm!" << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system ".test", "--verbose"
  end
end