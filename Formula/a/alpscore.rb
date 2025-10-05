class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://ghfast.top/https://github.com/ALPSCore/ALPSCore/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "bd9b5af0a33acc825ffedfaa0bf794a420ab2b9b50f6a4e634ecbde43ae9cc24"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "86681a415ce9b23f7664b88625224dd56d8a55c718e698f2627cf627a34a36a9"
    sha256 cellar: :any,                 arm64_sequoia: "f2ff9f51f2beb340a170abe4f12766fe64610c553ee3663b114b30e906bd63e6"
    sha256 cellar: :any,                 arm64_sonoma:  "9dd1b63f515a48f80865690450291d797cda75ac505fb75454c1a86fd50f8c7d"
    sha256 cellar: :any,                 sonoma:        "f104a219812971245726f55e4c1134f06871b6691f5730d90d6df3b243460410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97b22e40afaa673e367c222e424c8539d73e9c495e8a9e1660b2ff26fa94a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96e68846f519f016c8d6e661a6eebb6f8f2efbe44f8fc2ef6a64715fb825963"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "hdf5"
  depends_on "open-mpi"

  # Backport support for CMake 4
  patch do
    url "https://github.com/ALPSCore/ALPSCore/commit/155e4327a78c1fa9442a179868994c8715582720.patch?full_index=1"
    sha256 "9cb67c3d457a99fc799a60e8fcae0af63b99ebb18b5279b449ce9c0c1445077a"
  end

  # Apply open PR to support Eigen 5.0.0
  # PR ref: https://github.com/ALPSCore/ALPSCore/pull/651
  patch do
    url "https://github.com/ALPSCore/ALPSCore/commit/0a7952abb3570e48d04d435d7d9d16ecbd06fb2a.patch?full_index=1"
    sha256 "f007f65367528149ce5c4ad871aea600bbe05dd374c100588d577a07e3a05818"
  end

  def install
    # Work around different behavior in CMake-built HDF5
    inreplace "common/cmake/ALPSCommonModuleDefinitions.cmake" do |s|
      s.sub! "set(HDF5_NO_FIND_PACKAGE_CONFIG_FILE TRUE)", ""
      s.sub! "find_package (HDF5 1.10.2 ", "find_package (HDF5 "
    end

    args = %W[
      -DALPS_BUILD_SHARED=ON
      -DALPS_CXX_STD=c++14
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
      -DENABLE_MPI=ON
      -DTesting=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix Cellar references
    files_with_cellar_references = [
      share/"alps-utilities/alps-utilities.cmake",
      share/"alps-alea/alps-alea.cmake",
      share/"alps-gf/alps-gf.cmake",
      share/"alps-accumulators/alps-accumulators.cmake",
      share/"alps-mc/alps-mc.cmake",
      share/"alps-params/alps-params.cmake",
      share/"alps-hdf5/alps-hdf5.cmake",
    ]

    inreplace files_with_cellar_references do |s|
      s.gsub!(Formula["open-mpi"].prefix.realpath, Formula["open-mpi"].opt_prefix)
      s.gsub!(Formula["hdf5"].prefix.realpath, Formula["hdf5"].opt_prefix, audit_result: false)
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <alps/mc/api.hpp>
      #include <alps/mc/mcbase.hpp>
      #include <alps/accumulators.hpp>
      #include <alps/params.hpp>
      using namespace std;
      int main()
      {
        alps::accumulators::accumulator_set set;
        set << alps::accumulators::MeanAccumulator<double>("a");
        set["a"] << 2.9 << 3.1;
        alps::params p;
        p["myparam"] = 1.0;
        cout << set["a"] << endl << p["myparam"] << endl;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test)
      set(CMAKE_CXX_STANDARD 14)
      set(ALPS_FORCE_NO_COMPILER_CHECK TRUE)
      find_package(HDF5 REQUIRED)
      find_package(ALPSCore REQUIRED mc accumulators params)
      add_executable(test test.cpp)
      target_link_libraries(test ${ALPSCore_LIBRARIES})
    CMAKE

    system "cmake", "."
    system "cmake", "--build", "."
    assert_equal "3 #2\n1 (type: double) (name='myparam')\n", shell_output("./test")
  end
end