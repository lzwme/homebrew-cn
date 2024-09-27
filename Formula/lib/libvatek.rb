class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https:github.comVisionAdvanceTechnologyIncvatek_sdk_2"
  url "https:github.comVisionAdvanceTechnologyIncvatek_sdk_2archiverefstagsv3.11.tar.gz"
  sha256 "8d8cf457488ff8fde751f1cafd84fb4b987d4eb23d0ac61354c06391326e8582"
  license "BSD-2-Clause"
  head "https:github.comVisionAdvanceTechnologyIncvatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6d6c8c05881ec9a15906253bc42f54967efd4d3717e0ee68d4422babcd4ec3c"
    sha256 cellar: :any,                 arm64_sonoma:  "ed307aaecc322a4eeaaaeb56e00c831b182e4cf6484b20abf271194e7c5ea949"
    sha256 cellar: :any,                 arm64_ventura: "d73850143e2f5ea0e0f9184914da65ec87bc9eb498f3e92015f6e3ff478a99f3"
    sha256 cellar: :any,                 sonoma:        "04070a48aa12399f7c2a58ae2a8ac1e363c214e912d9de8dbe6a5d5157b3b3de"
    sha256 cellar: :any,                 ventura:       "b80cec12c22c2f0789d9d3c894d22d9d009968cade05889f27f6c119f487aaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23e5f02a0f74fa800cb01015d26125c1352a2fa57ee174a6f32770572e82586"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DSDK2_EN_QT=OFF", "-DSDK2_EN_APP=OFF", "-DSDK2_EN_SAMPLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath"vatek_test.c").write <<~EOS
      #include <vatek_sdk_device.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
          hvatek_devices hdevices = NULL;
          vatek_result devcount = vatek_device_list_enum(DEVICE_BUS_USB, service_transform, &hdevices);
          if (is_vatek_success(devcount)) {
              printf("passed\\n");
              return EXIT_SUCCESS;
          }
          else {
              printf("failed\\n");
              return EXIT_FAILURE;
          }
      }
    EOS
    system ENV.cc, "vatek_test.c", "-I#{include}vatek", "-L#{lib}", "-lvatek_core", "-o", "vatek_test"
    assert_equal "passed", shell_output(".vatek_test").strip
  end
end