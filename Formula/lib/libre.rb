class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.13.0.tar.gz"
  sha256 "de293bf0a55656e59325f8563814d185c8b459667c897a59d1acc952f86f4746"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf6581c54d21c7f38939430902f0ba4e129a450b05de211cfeeedf0e7a159737"
    sha256 cellar: :any,                 arm64_ventura:  "5c4dce55ea9a7e38a2bc02c2c0f7b91c04cbdb1cd18b442bc3116a38f0bca190"
    sha256 cellar: :any,                 arm64_monterey: "8eef7a91f1b5b97d323ee4937587b805087cb598e9dc5634dde3800c94dc6c47"
    sha256 cellar: :any,                 sonoma:         "80016d33e6891440aaf21090dc510f5b071b92b94d364ee373d3ab28e16ffb00"
    sha256 cellar: :any,                 ventura:        "8ecebdfbdc4d8e34bc21e49e5bb4f158509145a95cfec2caf1fa3f67857dc77f"
    sha256 cellar: :any,                 monterey:       "cab2219041ba4d4d1491e7120cb649c84e07648769a205c87589b638250e2208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ff7bc0c1660d455fe01c38ef10a36afa9246d3b701b0394b17decb1430b0ed"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end