class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https:www.actor-framework.org"
  url "https:github.comactor-frameworkactor-frameworkarchiverefstags1.0.0.tar.gz"
  sha256 "602018239d23a1805d35ebda704fd5c969a0693fc513fcf7459063b628459e5b"
  license "BSD-3-Clause"
  head "https:github.comactor-frameworkactor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a63a5aa28211a0dadd2e8d135e8f5647997e8fb54ec69691e1f1eef84a157804"
    sha256 cellar: :any,                 arm64_ventura:  "71b8d0b2907bc4baad183a8c54e80dbb51df9cb6520f839ee1d5929ad6c4bf3e"
    sha256 cellar: :any,                 arm64_monterey: "585707c8f60c1454b3f89d410be4f651ac868908b7b84aeb05fda37a5f8f3db7"
    sha256 cellar: :any,                 sonoma:         "10fdb01a82137953bf208ccb24eda15f1f9ebb2001d692e8b021b083f29046c4"
    sha256 cellar: :any,                 ventura:        "0864c53b313bf1477380fc7190665ed1bc718e33c3d4a2d4d0b048302a585961"
    sha256 cellar: :any,                 monterey:       "f01bbe863c0f45190cd194e7fd8af032f164b1993918a67224664d207ce20f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec37965bee21156037686db4319eb260d02562f77f21138a23a9a73878f43268"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    tools = pkgshare"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <cafall.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system ".test"
  end
end