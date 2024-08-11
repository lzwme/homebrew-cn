class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https:esa.github.iopagmo2"
  url "https:github.comesapagmo2archiverefstagsv2.19.1.tar.gz"
  sha256 "ecc180e669fa6bbece959429ac7d92439e89e1fd1c523aa72b11b6c82e414a1d"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8f35d3b0588fa8f2e7e7e4ec2aafb766b021e15931860cd7c34df9ba8a64a35"
    sha256 cellar: :any,                 arm64_ventura:  "cfc3a9d4f379ae2ad175d43391b0a9e8c568b2e189fe609a7f86d1790e302fe9"
    sha256 cellar: :any,                 arm64_monterey: "58b3acd3f9cc46b4519b11e9fc8f8775d175788e71fad83f048d0bf160d9add3"
    sha256 cellar: :any,                 sonoma:         "1e1c4355c5f39f8abfe607cff474b9900b8bcf118465d462a26e736a4268c910"
    sha256 cellar: :any,                 ventura:        "a8e15e8340724b8c52918b7a510c952c5c38eb27e03290166b6185b4757fa0b9"
    sha256 cellar: :any,                 monterey:       "7461578677e3db9bd5e3dd35211a89802287b5cfcdaf45c254f2459b82c46d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683df2636a3ed1fd93c401f0bbf9a0cf4fcdd33558bfce295f519d6f6aa9eed2"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DPAGMO_WITH_EIGEN3=ON", "-DPAGMO_WITH_NLOPT=ON",
                         *std_cmake_args,
                         "-DCMAKE_CXX_STANDARD=17"
    system "make", "install"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>

      #include <pagmoalgorithm.hpp>
      #include <pagmoalgorithmssade.hpp>
      #include <pagmoarchipelago.hpp>
      #include <pagmoproblem.hpp>
      #include <pagmoproblemsschwefel.hpp>

      using namespace pagmo;

      int main()
      {
           1 - Instantiate a pagmo problem constructing it from a UDP
           (i.e., a user-defined problem, in this case the 30-dimensional
           generalised Schwefel test function).
          problem prob{schwefel(30)};

           2 - Instantiate a pagmo algorithm (self-adaptive differential
           evolution, 100 generations).
          algorithm algo{sade(100)};

           3 - Instantiate an archipelago with 16 islands having each 20 individuals.
          archipelago archi{16u, algo, prob, 20u};

           4 - Run the evolution in parallel on the 16 separate islands 10 times.
          archi.evolve(10);

           5 - Wait for the evolutions to finish.
          archi.wait_check();

           6 - Print the fitness of the best solution in each island.
          for (const auto &isl : archi) {
              std::cout << isl.get_population().champion_f()[0] << std::endl;
          }

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++17", "-o", "test"
    system ".test"
  end
end