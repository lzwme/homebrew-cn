class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https:github.combrainboxdotccDPP"
  url "https:github.combrainboxdotccDPPreleasesdownloadv10.1.1DPP-10.1.1.tar.gz"
  sha256 "73b57a2b0927d4b5903b78a51cc4284ce0c95d036ee597aec186bf4a4cd78d59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bad7f54006ffbacf0aba9c3b2a885d3f4b74a806e15d1223f1dd5bad4ced9056"
    sha256 cellar: :any,                 arm64_sonoma:  "c570589d7fe57444c4adda82441a248155401e14313a72c606452fbadca9fa70"
    sha256 cellar: :any,                 arm64_ventura: "1f4d905bc6316a087039baad7a5c4e136665ea1a1369069899e2edb3d847b9ad"
    sha256 cellar: :any,                 sonoma:        "40554f22aed94409134ff1d513ef3e1e5d5c266aab079b4efacc981d21f18a69"
    sha256 cellar: :any,                 ventura:       "c82a9c2047b8cb48516115c6fb4ad70aaf22e57c51e466120e68fdc840f6613b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21b944344898a71fbefbaa29069f16c9d4df841359f9455f7ca354731a90d98"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pkgconf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DDPP_BUILD_TEST=OFF",
                    "-DDPP_NO_CONAN=ON",
                    "-DDPP_NO_VCPKG=ON",
                    "-DDPP_USE_EXTERNAL_JSON=ON",
                    "-DRUN_LDCONFIG=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <dppdpp.h>
      #include <unistd.h>  for alarm

      void timeout_handler(int signum) {
          std::cerr << "Connection error: timed out" << std::endl;
          exit(1);
      }

      int main() {
          std::signal(SIGALRM, timeout_handler);
          alarm(2);

          dpp::cluster bot("invalid_token");

          bot.on_log(dpp::utility::cout_logger());

          try {
              bot.start(dpp::st_wait);
          }
          catch (const dpp::connection_exception &e) {
              std::cout << "Connection error: " << e.what() << std::endl;
              return 1;
          }
          catch (const dpp::invalid_token_exception &e) {
              std::cout << "Invalid token." << std::endl;
              return 1;
          }
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_match "Connection error", shell_output(".test 2>&1", 1)
  end
end