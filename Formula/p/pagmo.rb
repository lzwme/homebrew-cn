class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https:esa.github.iopagmo2"
  url "https:github.comesapagmo2archiverefstagsv2.19.0.tar.gz"
  sha256 "701ada528de7d454201e92a5d88903dd1c22ea64f43861d9694195ddfef82a70"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc2d1c9edcdcfaf51c85cca6c0215544ed8b4cc300d6e36006a7fbd84a60171d"
    sha256 cellar: :any,                 arm64_ventura:  "603565368150728e746fce2bd1601f910c35998ef8568ffa450ba7cda951eb02"
    sha256 cellar: :any,                 arm64_monterey: "5e9a8ad995b67e850fd80262dfa7830c61bd78c31f17a7fb95dec003756a4a03"
    sha256 cellar: :any,                 sonoma:         "97a41b9bdcc33c065e2fd1c83032826a152d4657305fb327639611153b328790"
    sha256 cellar: :any,                 ventura:        "880c9b2c6e6753afc2577fb196629794e5a2d6342215aeb2d56adaff2bb9bb8c"
    sha256 cellar: :any,                 monterey:       "bb7976df491489c437701247c941393e0d033c6bda7032535fc185bac3d17fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ceba84515192452743c2649f8f08f30e31ccd3c11fec6fd9fdc2205dc0d332"
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