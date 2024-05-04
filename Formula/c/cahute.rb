class Cahute < Formula
  include Language::Python::Virtualenv

  desc "Library and set of utilities to interact with Casio calculators"
  homepage "https://cahuteproject.org/"
  url "https://ftp.cahuteproject.org/releases/cahute-0.3.tar.gz"
  sha256 "e84fdcbfc901b7818900fd959dab110a8aeb7d17ad8ac2f79287436d2519fdfa"
  license "CECILL-2.1"

  livecheck do
    url "https://ftp.cahuteproject.org/releases/"
    regex(/href=.*?cahute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46fe8c8ab653ec56112c6fd96406994fa567011dc1d3425156d73a81dc7bed39"
    sha256 cellar: :any,                 arm64_ventura:  "0bd334ccd2db852cf3735d20600aebc9265de06ad4f21ad1aa0fcd38d3324fb7"
    sha256 cellar: :any,                 arm64_monterey: "4466934190794da649d849ddae4c984df811ae3de9f3e53db30102f6e81292a2"
    sha256 cellar: :any,                 sonoma:         "ab48a6aa740266190822d1d3bdd9f7361b64d53c0aa72991762c37d1c2ca6f01"
    sha256 cellar: :any,                 ventura:        "79d22f701a7d923c734f3d0923eaa2fe9e0533661409c06b276422b0c76f10d1"
    sha256 cellar: :any,                 monterey:       "ee24ab155ca2843e61ccaa72ddeaa68243c001889fe2b84b7b92f4f674f5f7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83b54623bd76091437b6bd5104e6eb150508ca7f3556293dc6c95198c97f1d3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "libusb"
  depends_on "sdl2"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.12")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build", "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Assume that there is no calculator connected while testing
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/p7 idle 2>&1", 1)
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/p7screen 2>&1", 1)

    # xfer9860 is a reimplementation of an older program of the same name, which does not indicate
    # a failure exit code when a calculator isn't present. So here, we expect a successful exit
    # status but an error message printed to the console.
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/xfer9860 -i 2>&1")

    # No calculator is connected, so this will also fail. Any test file will do.
    shell_output("#{bin}/p7os flash #{test_fixtures "test.ico"} 2>&1", 1)

    # Taken from https://cahuteproject.org/developer-guides/detection/usb.html
    (testpath/"usb-detect.c").write <<~EOS
      #include <stdio.h>
      #include <cahute.h>

      int my_callback(void *cookie, cahute_usb_detection_entry const *entry) {
          char const *type_name;

          switch (entry->cahute_usb_detection_entry_type) {
          case CAHUTE_USB_DETECTION_ENTRY_TYPE_SEVEN:
              type_name = "fx-9860G or compatible";
              break;

          case CAHUTE_USB_DETECTION_ENTRY_TYPE_SCSI:
              type_name = "fx-CG or compatible";
              break;

          default:
              type_name = "(unknown)";
          }

          printf("New entry data:\\n");
          printf(
              "- Address: %03d:%03d\\n",
              entry->cahute_usb_detection_entry_bus,
              entry->cahute_usb_detection_entry_address
          );
          printf("- Type: %s\\n", type_name);

          return 0;
      }

      int main(void) {
          int err;

          err = cahute_detect_usb(&my_callback, NULL);
          if (err)
              fprintf(stderr, "Cahute has returned error 0x%04X.\\n", err);

          return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs cahute libusb-1.0").strip.split
    system ENV.cc, "usb-detect.c", *pkg_config_cflags, "-o", "usb-detect"
    system "./usb-detect"
  end
end