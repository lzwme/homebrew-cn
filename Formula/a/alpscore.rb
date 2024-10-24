class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https:alpscore.org"
  url "https:github.comALPSCoreALPSCorearchiverefstagsv2.3.1.tar.gz"
  sha256 "384f25cd543ded1ac99fe8238db97a5d90d24e1bf83ca8085f494acdd12ed86c"
  license "GPL-2.0-only"
  revision 2
  head "https:github.comALPSCoreALPSCore.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "29c6ede223583eed8c36de8efc88aa516fc5a7ef2c2e95e2608ec560dce28271"
    sha256 cellar: :any,                 arm64_sonoma:  "a7de097346c1a2dc6f21b04cc6a5e1b226de60e863af74ee8fc93a9273e04dd1"
    sha256 cellar: :any,                 arm64_ventura: "b190400e560789f65a14137da3b2ea97bc320578dafdda367d38dac3a10b854d"
    sha256 cellar: :any,                 sonoma:        "c92e9a635a0c4b249bbe3c7ac3eedd003791547c0ac24536414e4e51048e7014"
    sha256 cellar: :any,                 ventura:       "5efb507ba18bf0ee8dab3ccce424d3accb15e5a6a3a8386460bd286fd1a117d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8aa15df04e08a496efa4df6c4884e2ca3214fd7374f35fe04264240da43b232"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "hdf5"
  depends_on "open-mpi"

  def install
    # Work around different behavior in CMake-built HDF5
    inreplace "commoncmakeALPSCommonModuleDefinitions.cmake" do |s|
      s.sub! "set(HDF5_NO_FIND_PACKAGE_CONFIG_FILE TRUE)", ""
      s.sub! "find_package (HDF5 1.10.2 ", "find_package (HDF5 "
    end

    args = %W[
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}eigen3
      -DALPS_BUILD_SHARED=ON
      -DENABLE_MPI=ON
      -DTesting=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix Cellar references
    files_with_cellar_references = [
      share"alps-utilitiesalps-utilities.cmake",
      share"alps-aleaalps-alea.cmake",
      share"alps-gfalps-gf.cmake",
      share"alps-accumulatorsalps-accumulators.cmake",
      share"alps-mcalps-mc.cmake",
      share"alps-paramsalps-params.cmake",
      share"alps-hdf5alps-hdf5.cmake",
    ]

    inreplace files_with_cellar_references do |s|
      s.gsub!(Formula["open-mpi"].prefix.realpath, Formula["open-mpi"].opt_prefix)
      s.gsub!(Formula["hdf5"].prefix.realpath, Formula["hdf5"].opt_prefix, audit_result: false)
    end
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <alpsmcapi.hpp>
      #include <alpsmcmcbase.hpp>
      #include <alpsaccumulators.hpp>
      #include <alpsparams.hpp>
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
    EOS

    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      set(CMAKE_CXX_STANDARD 11)
      find_package(HDF5 REQUIRED)
      find_package(ALPSCore REQUIRED mc accumulators params)
      add_executable(test test.cpp)
      target_link_libraries(test ${ALPSCore_LIBRARIES})
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
    assert_equal "3 #2\n1 (type: double) (name='myparam')\n", shell_output(".test")
  end
end