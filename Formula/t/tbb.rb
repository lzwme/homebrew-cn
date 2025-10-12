class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://uxlfoundation.github.io/oneTBB/"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v2022.2.0.tar.gz"
  sha256 "f0f78001c8c8edb4bddc3d4c5ee7428d56ae313254158ad1eec49eced57f6a5b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "562449162ee64e94b9bcfe57a1287e8f7948692b91c1c05feb84c171d3db1190"
    sha256 cellar: :any,                 arm64_sequoia: "08bff4f7e78623c9b7e9b61c6810b00ed5b232f11f811d120bf88d5f2df56008"
    sha256 cellar: :any,                 arm64_sonoma:  "6d7b9c81ae0e307a141bd1a574f14c0e1cc7f6edf561493c8e6ea2191acad6ac"
    sha256 cellar: :any,                 sonoma:        "630005415bc765dfb56ac82e140455cf20d587ef3df4b9feb89a61665e4af9da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3a77b27a5e4cd320c0c5300ae867ccddc4766a249a639a83945a37119a929a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e75bda17f7c53f25c2f885037344cf5986a5ebbb30abbd72bfe1ed31f813c05"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  def python3
    "python3.14"
  end

  def install
    # Prevent `setup.py` from installing tbb4py as a deprecated egg directly into HOMEBREW_PREFIX.
    # We need this due to our Python patch.
    site_packages = Language::Python.site_packages(python3)
    inreplace "python/CMakeLists.txt",
              "install --prefix build -f",
              "\\0 --install-lib build/#{site_packages} --single-version-externally-managed --record=RECORD"

    tbb_site_packages = prefix/site_packages/"tbb"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath},-rpath,#{rpath(source: tbb_site_packages)}"

    args = %W[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
      -DPYTHON_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install buildpath.glob("build/static/*/libtbb*.a")
  end

  test do
    # The glob that installs these might fail,
    # so let's check their existence.
    assert_path_exists lib/"libtbb.a"
    assert_path_exists lib/"libtbbmalloc.a"

    (testpath/"cores-types.cpp").write <<~CPP
      #include <cstdlib>
      #include <tbb/task_arena.h>

      int main() {
          const auto numa_nodes = tbb::info::numa_nodes();
          const auto size = numa_nodes.size();
          const auto type = numa_nodes.front();
          return size != 1 || type != tbb::task_arena::automatic ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    CPP

    system ENV.cxx, "cores-types.cpp", "-std=c++14", "-DTBB_PREVIEW_TASK_ARENA_CONSTRAINTS_EXTENSION=1",
                                      "-L#{lib}", "-ltbb", "-o", "core-types"
    system "./core-types"

    (testpath/"sum1-100.cpp").write <<~CPP
      #include <iostream>
      #include <tbb/blocked_range.h>
      #include <tbb/parallel_reduce.h>

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
    assert_equal "5050", shell_output("./sum1-100").chomp

    system python3, "-c", "import tbb"
  end
end