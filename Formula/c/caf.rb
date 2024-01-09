class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https:www.actor-framework.org"
  url "https:github.comactor-frameworkactor-frameworkarchiverefstags0.19.5.tar.gz"
  sha256 "7eedfa9bc4d508185de12417f552f360812103a279ce9def568bffa8c512cbb4"
  license "BSD-3-Clause"
  head "https:github.comactor-frameworkactor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9fdc4a13349ab6415a8c31d84949e5a5faea80ed604aee7869707900e2f4406"
    sha256 cellar: :any,                 arm64_ventura:  "bff9ccf3ca63327d745dd2fead93cfc79f58cccde0b434d2d8c5f324797b43d0"
    sha256 cellar: :any,                 arm64_monterey: "2d9da652ed5f0063794b097329b904927a40070322649a23b853b1fb6c39d5bf"
    sha256 cellar: :any,                 sonoma:         "370d46693e0b6dd36b3254d1ffdc72629d2e474dd6f3e92c91da1c17eaa87f16"
    sha256 cellar: :any,                 ventura:        "2c179a74e02328bfb8bc85ffa0fd803a662a4c9c622826d302753791869980ac"
    sha256 cellar: :any,                 monterey:       "e4e11662b25bae3be84e26b1475cf446862caf4023b03856babc505c6f23723d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00b997791a5d902bbb1dd71a8a86c459832626bcc539dc830bf9439b8c827e81"
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