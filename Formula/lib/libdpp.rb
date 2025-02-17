class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https:github.combrainboxdotccDPP"
  url "https:github.combrainboxdotccDPPreleasesdownloadv10.1.0DPP-10.1.0.tar.gz"
  sha256 "c794053b926c019e8f4771523362ecfdf3038a7899bad4400c163bd1e13584e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e041426c1fbfe60b1f751fd4223a5daae7d6b01f51f7398058f91b330c07c55e"
    sha256 cellar: :any,                 arm64_sonoma:  "7d1f71ae80c3b9f1af8ca633658092b75d01545eb7a32d5eaac79674633b5a7a"
    sha256 cellar: :any,                 arm64_ventura: "cc4dbaf15b453c352c5af33ed24259245832edb50354bdcf2eb508f8839ce973"
    sha256 cellar: :any,                 sonoma:        "a187b0a03194c894eb3dd574585ecadb53b3885385f0a76f480ae9dd6e054169"
    sha256 cellar: :any,                 ventura:       "0dda8005329206e980a1e0aa5875f0193ebc5df90839a1e6e321e68a169c7463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e268ad44b11da37020f457c7ae9108057a286d989adc38780e9362326bfce2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pkgconf"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDPP_BUILD_TEST=OFF", *std_cmake_args
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