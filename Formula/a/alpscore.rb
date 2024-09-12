class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https:alpscore.org"
  url "https:github.comALPSCoreALPSCorearchiverefstagsv2.3.1.tar.gz"
  sha256 "384f25cd543ded1ac99fe8238db97a5d90d24e1bf83ca8085f494acdd12ed86c"
  license "GPL-2.0-only"
  head "https:github.comALPSCoreALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c54e6e341b63702d2a48f40524292629b611cb5ab88a0cb6604314b624529f59"
    sha256 cellar: :any,                 arm64_sonoma:   "aef5c5bfae1874fde2ec165976bd8bb9d9843ea5c6869d450ebf30f108d35bdb"
    sha256 cellar: :any,                 arm64_ventura:  "e34b2a4bd898d1db42632434afd1439e71f56e834760888b1765c5ee99ff8c19"
    sha256 cellar: :any,                 arm64_monterey: "1a3d2fc86adcd59f3c27947e7e31f8ca1e560a5b24929e7d5afc7d17a3e5b5e3"
    sha256 cellar: :any,                 arm64_big_sur:  "d49c1218dbc5937dd219f56756ab75d274b43e37bce1c63d07441f399391beb6"
    sha256 cellar: :any,                 sonoma:         "e55aed9a454d8c9637fbb9db8a5f858aaf58fefbbb7f29e94877917576e4a0ee"
    sha256 cellar: :any,                 ventura:        "0fc15615066580361a0956a6160028c1a67d4ef998d7c1bacfd2ccab98fd168e"
    sha256 cellar: :any,                 monterey:       "5193c9aaafd61add135a872dd9623137427d0baa6598789cf682bcbfa6bd8e76"
    sha256 cellar: :any,                 big_sur:        "c874985418a753e947fe350a1389621669c2ddfa67890d7d32d14540d05ef20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6159afbf12d22d9d08a30e69a785d9bb77e595145937857e5e8c3ceb273582d"
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