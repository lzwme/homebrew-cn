class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https:github.comoneapi-srconeTBB"
  url "https:github.comoneapi-srconeTBBarchiverefstagsv2021.13.0.tar.gz"
  sha256 "3ad5dd08954b39d113dc5b3f8a8dc6dc1fd5250032b7c491eb07aed5c94133e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e9ed982a18c3dac9d8db3d64fd2a8c0b157adb846103c0a9315d1f67eef25cd"
    sha256 cellar: :any,                 arm64_ventura:  "fcae42945dc2c556b9dabcc9645646fcb36a7ceb48c07dd0029e840d3bcb1b48"
    sha256 cellar: :any,                 arm64_monterey: "b5837d8c9c05831661606c47e210dfb2889a72e26b5d88b51ef081694410c76f"
    sha256 cellar: :any,                 sonoma:         "1c368b6566070dc6c527d82484d2f18a1fee5dd296ae05c67888bf7a080dc14e"
    sha256 cellar: :any,                 ventura:        "992efbcc88b69ab097794e969439994a90c5fd39af45023b2953dc53f7d05699"
    sha256 cellar: :any,                 monterey:       "ed6b5b509b170c2a0003a63fae7c9d364195963bcb0f3a9788448d3ebc834622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5798f4862bf605ae914e0116e8cd9baaf65102279a553c9f588e32004cae2bb1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on "hwloc"

  def python3
    "python3.12"
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

    args = %w[
      -DTBB_TEST=OFF
      -DTBB4PY_BUILD=ON
    ]

    system "cmake", "-S", ".", "-B", "buildshared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", ".", "-B", "buildstatic",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install buildpath.glob("buildstatic*libtbb*.a")
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