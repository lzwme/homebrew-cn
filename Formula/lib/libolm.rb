class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.16/olm-3.2.16.tar.gz"
  sha256 "1e90f9891009965fd064be747616da46b232086fe270b77605ec9bda34272a68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2dd9100bb3f29d104f285aa65085e786e4649709dbc66b057237085b3be32111"
    sha256 cellar: :any,                 arm64_ventura:  "a98d48d4e45696f2645160b4aa2f345b58e3c61656c13ae8ded57bf2854e2d14"
    sha256 cellar: :any,                 arm64_monterey: "2a8281300559d3538a102fd502f0e000c98d86acc6c35a99a0cb5294df7034f2"
    sha256 cellar: :any,                 sonoma:         "ed06e4f79c3f1651dd77425482b55bb9876ead8c80adaacc7aaccd6def7f4f76"
    sha256 cellar: :any,                 ventura:        "dfcc8778b58afac8e598e6f83fbefd6a18d2c34a2c23b23e332c4618847f4476"
    sha256 cellar: :any,                 monterey:       "71019cfeedbd48f15b86c6249bcd4db630fc6aae5754ee2e6f0162615bf55fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f116c980f972a0fe05051d0bedae1cd42392051566d51c9f25989639d6b05a37"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-Bbuild", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <vector>
      #include <stdlib.h>

      #include "olm/olm.h"

      using std::cout;

      int main() {
        void * utility_buffer = malloc(::olm_utility_size());
        ::OlmUtility * utility = ::olm_utility(utility_buffer);

        uint8_t output[44];
        ::olm_sha256(utility, "Hello, World", 12, output, 43);
        output[43] = '\0';
        cout << output;
        return 0;
      }
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lolm", "-lstdc++", "-o", "test"
    assert_equal "A2daxT/5zRU1zMffzfosRYxSGDcfQY3BNvLRmsH76KU", shell_output("./test").strip
  end
end