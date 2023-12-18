class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https:github.comoneapi-srconeTBB"
  url "https:github.comoneapi-srconeTBBarchiverefstagsv2021.11.0.tar.gz"
  sha256 "782ce0cab62df9ea125cdea253a50534862b563f1d85d4cda7ad4e77550ac363"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c24bd15b42e0ae13e2cb12ac655a48719925625160e881ebe3f7106abe3c080d"
    sha256 cellar: :any,                 arm64_ventura:  "a648bac2b48fe462ccba3ba5791d753b01ecc5ec8ee84fa4b86f2e34e2d7442e"
    sha256 cellar: :any,                 arm64_monterey: "e9ff0aba06130659e53186ff76c843e922eeba909c19ccb9d1c4274cc51dcc38"
    sha256 cellar: :any,                 sonoma:         "ac700eb4d553a63441a0b493aa30cd1b5b82d0d740293ae74e10d6f1f61c119d"
    sha256 cellar: :any,                 ventura:        "b467ab5ad3cc9139e861a3d40059e83cbbcc5cfdddf7b8474a866cdbc9fe3bb5"
    sha256 cellar: :any,                 monterey:       "757139751fed233518ed43992f0427b87cdf461459fd4ff2f6dabc759855acee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d73744e801e49bedfc00ad68838cd6299a50563bf69c270f2808ad51bd7562"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  # Fix installation of Python components
  # See See https:github.comoneapi-srconeTBBissues343
  patch :DATA

  def python3
    "python3.12"
  end

  def install
    # Prevent `setup.py` from installing tbb4py directly into HOMEBREW_PREFIX.
    # We need this due to our Python patch.
    site_packages = Language::Python.site_packages(python3)
    inreplace "pythonCMakeLists.txt", "@@SITE_PACKAGES@@", site_packages

    tbb_site_packages = prefixsite_packages"tbb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath},-rpath,#{rpath(source: tbb_site_packages)}"

    args = %w[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
    ]

    system "cmake", "-S", ".", "-B", "buildshared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", ".", "-B", "buildstatic",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install buildpath.glob("buildstatic*libtbb*.a")

    cd "python" do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["TBBROOT"] = prefix

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib"libtbb.a"
    assert_path_exists lib"libtbbmalloc.a"

    (testpath"cores-types.cpp").write <<~EOS
      #include <cstdlib>
      #include <tbbtask_arena.h>

      int main() {
          const auto numa_nodes = tbb::info::numa_nodes();
          const auto size = numa_nodes.size();
          const auto type = numa_nodes.front();
          return size != 1 || type != tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "cores-types.cpp", "--std=c++14", "-DTBB_PREVIEW_TASK_ARENA_CONSTRAINTS_EXTENSION=1",
                                      "-L#{lib}", "-ltbb", "-o", "core-types"
    system ".core-types"

    (testpath"sum1-100.cpp").write <<~EOS
      #include <iostream>
      #include <tbbblocked_range.h>
      #include <tbbparallel_reduce.h>

      int main()
      {
        auto total = tbb::parallel_reduce(
          tbb::blocked_range<int>(0, 100),
          0.0,
          [&](tbb::blocked_range<int> r, int running_total)
          {
            for (int i=r.begin(); i < r.end(); ++i) {
              running_total += i + 1;
            }

            return running_total;
          }, std::plus<int>()
        );

        std::cout << total << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "sum1-100.cpp", "--std=c++14", "-L#{lib}", "-ltbb", "-o", "sum1-100"
    assert_equal "5050", shell_output(".sum1-100").chomp

    system python3, "-c", "import tbb"
  end
end

__END__
diff --git apythonCMakeLists.txt bpythonCMakeLists.txt
index 748921a5..d03fdc6f 100644
--- apythonCMakeLists.txt
+++ bpythonCMakeLists.txt
@@ -40,7 +40,7 @@ add_custom_target(
     ${PYTHON_EXECUTABLE} ${PYTHON_BUILD_WORK_DIR}setup.py
         build -b${PYTHON_BUILD_WORK_DIR}
         build_ext ${TBB4PY_INCLUDE_STRING} -L$<TARGET_FILE_DIR:TBB::tbb>
-        install --prefix build -f
+        install --prefix build --install-lib ${PYTHON_BUILD_WORK_DIR}build@@SITE_PACKAGES@@ -f
     COMMENT "Build and install to work directory the oneTBB Python module"
 )
 
@@ -50,7 +50,7 @@ add_test(NAME python_test
                  -DPYTHON_MODULE_BUILD_PATH=${PYTHON_BUILD_WORK_DIR}build
                  -P ${PROJECT_SOURCE_DIR}cmakepythontest_launcher.cmake)
 
-install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}${PYTHON_BUILD_WORK_DIR}build
+install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}${PYTHON_BUILD_WORK_DIR}
         DESTINATION .
         COMPONENT tbb4py)