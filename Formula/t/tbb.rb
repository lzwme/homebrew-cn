class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https:github.comoneapi-srconeTBB"
  url "https:github.comoneapi-srconeTBBarchiverefstagsv2022.0.0.tar.gz"
  sha256 "e8e89c9c345415b17b30a2db3095ba9d47647611662073f7fbf54ad48b7f3c2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38fdf780cbe726dfd23dc3f44a8404e493dd15a25f789192eb07078c424315b8"
    sha256 cellar: :any,                 arm64_sonoma:  "395ce725fdf9f2729a6dfc987bfbd6593252c3052e93ec739d8b2f28b257214b"
    sha256 cellar: :any,                 arm64_ventura: "c2d23d00a088900e6d6ec91a75ec2f3b972740790ef4156ac28cbbf4d187f3a4"
    sha256 cellar: :any,                 sonoma:        "a273e031b766bc13c5203afd089a92a97147bd6ffe9eccc8c4b11b58e69b4d8e"
    sha256 cellar: :any,                 ventura:       "fed7b2e7350ce93f50338acaa44258efd637800f97eae90af0fad84533d848fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e0fbee4d1f60809fb238ccaf5bd89a9b97c08afc93378f083dace474521ef4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  def python3
    "python3.13"
  end

  def install
    # Prevent `setup.py` from installing tbb4py as a deprecated egg directly into HOMEBREW_PREFIX.
    # We need this due to our Python patch.
    site_packages = Language::Python.site_packages(python3)
    inreplace "pythonCMakeLists.txt",
              "install --prefix build -f",
              "\\0 --install-lib build#{site_packages} --single-version-externally-managed --record=RECORD"

    tbb_site_packages = prefixsite_packages"tbb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath},-rpath,#{rpath(source: tbb_site_packages)}"

    args = %W[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
      -DPYTHON_EXECUTABLE=#{which(python3)}
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
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib"libtbb.a"
    assert_path_exists lib"libtbbmalloc.a"

    (testpath"cores-types.cpp").write <<~CPP
      #include <cstdlib>
      #include <tbbtask_arena.h>

      int main() {
          const auto numa_nodes = tbb::info::numa_nodes();
          const auto size = numa_nodes.size();
          const auto type = numa_nodes.front();
          return size != 1 || type != tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    CPP

    system ENV.cxx, "cores-types.cpp", "-std=c++14", "-DTBB_PREVIEW_TASK_ARENA_CONSTRAINTS_EXTENSION=1",
                                      "-L#{lib}", "-ltbb", "-o", "core-types"
    system ".core-types"

    (testpath"sum1-100.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "sum1-100.cpp", "-std=c++14", "-L#{lib}", "-ltbb", "-o", "sum1-100"
    assert_equal "5050", shell_output(".sum1-100").chomp

    system python3, "-c", "import tbb"
  end
end