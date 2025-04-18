class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https:github.comopenzimlibzim"
  url "https:github.comopenzimlibzimarchiverefstags9.3.0.tar.gz"
  sha256 "791220e51e6a160d349491b9744ec1a9c1a104f11a79e8e73673daf242be69ed"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ae5f6338f83f7dd1066db6a7803db05a345be240d1b63c6c2adabeafc59255e6"
    sha256 cellar: :any, arm64_sonoma:  "0085062d968e015fa500cfc3b6906c0a973b060a080c2050712d61d078b99032"
    sha256 cellar: :any, arm64_ventura: "ff15c3a85b96b4ff700407995f21834154be63da948e20971eaa01054c81e038"
    sha256 cellar: :any, sonoma:        "fd9d8b9902e2734b49b776e1bacc26903079bea81f4451a9367684e26b5aac94"
    sha256 cellar: :any, ventura:       "b63ab05850b5f97e6b971bdf2fd9e36bfbd0f118fd938f91bfbd83af359aec56"
    sha256               arm64_linux:   "d991cc599a050ed8e76484fab47c44bf40f20b91a2545a3f50c9a1fc870398b4"
    sha256               x86_64_linux:  "0426c12ee2d6a7f2e6e02c1e063163a3152199d0e8c512c8944e17122893eebb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@77"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  # Apply commit from open PR to fix build with ICU 76+
  # PR ref: https:github.comopenzimlibzimpull936
  patch do
    url "https:github.comopenzimlibzimcommit48c8c3fa7ad7a54f6df9a5be2676d189bbaf0022.patch?full_index=1"
    sha256 "f88890feab66aec7861b4eaab58202d6417c7c4d3692fe56f0e4b5fba06c64a3"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <zimversion.h>
      int main(void) {
        zim::printVersions();  first line should print "libzim <version>"
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output(".test")
  end
end