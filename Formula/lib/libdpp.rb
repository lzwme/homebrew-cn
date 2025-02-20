class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https:github.combrainboxdotccDPP"
  url "https:github.combrainboxdotccDPPreleasesdownloadv10.1.0DPP-10.1.0.tar.gz"
  sha256 "c794053b926c019e8f4771523362ecfdf3038a7899bad4400c163bd1e13584e3"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "cb77910370788f5e76d754b8af942de607af64be8a0d4d54bb1873b640bd0f09"
    sha256 cellar: :any,                 arm64_sonoma:  "d0f9149351006277ca0adb82fc28373f079737120a4b848b4aa86f9cd025a42b"
    sha256 cellar: :any,                 arm64_ventura: "b1f6b78be46f887a9ee35eaf55a80677a3565c8877a42353bfc5fbe31f25a3b6"
    sha256 cellar: :any,                 sonoma:        "bea496c05d0e5421ab9099bc2cf497909484450a3e1b723d3fd8d86f7fc60815"
    sha256 cellar: :any,                 ventura:       "658e968e1df3e5562da1da0648d37c45c5246664cc63d46d7d904d9c06e27df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f49b2d9cd65d0dfc27cf75ea7ce866a57b00b0f70f8e2797f307f3c60bf22b1"
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