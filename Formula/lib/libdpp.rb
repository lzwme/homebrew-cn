class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https:github.combrainboxdotccDPP"
  url "https:github.combrainboxdotccDPPreleasesdownloadv10.0.34DPP-10.0.34.tar.gz"
  sha256 "58eee75e81ac305db0b71a8cd4b821ff3cabcdfa0575e56ba5e4ce543531bd2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a075bd776660c37b349ef2e6c86ad37c5813ed9e33648f3fe47888262b2574ff"
    sha256 cellar: :any,                 arm64_sonoma:  "2bb8f8d74451bd379aad11459903bc3c2a2c9cdb27984693a3806542be615bc1"
    sha256 cellar: :any,                 arm64_ventura: "aaade5bfb2eaadc80cb5486d6c942d04c2082c1be4190aecf7716f0d6623f28a"
    sha256 cellar: :any,                 sonoma:        "81ec988d349f7149e529c7bb078e8fe4b4b3ac9a260c36550583227a47ddce2f"
    sha256 cellar: :any,                 ventura:       "228260124303ed832363531f72a943c496618a99fef085342a0b566c21aa60e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ce18c7568f4a581a82a211f6e68d61bf3c63150b59276e61a840827fb97bbb2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pkg-config"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDPP_CORO=on", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <dppdpp.h>

      int main() {
        dpp::cluster bot("invalid_token");

        bot.on_log(dpp::utility::cout_logger());

        try {
          bot.start(dpp::st_wait);
        }
        catch (const dpp::connection_exception& e) {
          std::cout << "Connection error: " << e.what() << std::endl;
          return 1;
        }
        catch(dpp::invalid_token_exception& e) {
          std::cout << "Invalid token." << std::endl;
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_match "Connection error", shell_output(".test 2>&1", 1)
  end
end