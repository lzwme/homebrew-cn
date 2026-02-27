class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://ghfast.top/https://github.com/pantoniou/libfyaml/releases/download/v0.9.5/libfyaml-0.9.5.tar.gz"
  sha256 "9acbc9737808b2833a51be0d4b361987ab6bbbb19cbda7c0c5c83148c8addd8a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a1c6453aa2a153ddc79bbe5b429b988e5d0a31bd18a50172da467beba2941a3"
    sha256 cellar: :any,                 arm64_sequoia: "32a2e507ebd357bf42e71c19800d19387dbb65eac12f845aaeee0a77c8d301e3"
    sha256 cellar: :any,                 arm64_sonoma:  "f1f552b26b42381f48a42dea7e4bb7c74ad65e185d2c72fa4f7d2c03540ecee5"
    sha256 cellar: :any,                 sonoma:        "58758c10fc12005bc8d05dbaa4200c3ae6b254c8b84e620636086c28e211d83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e66a8d3e1c4c92ccdab1b6b0272e64d4f81d4369e3f778aa087c29360f03e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5e3496da4781e79869fe19ca50a7c33c3be9a42c3fb40011cb142cf5882086"
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #ifdef HAVE_CONFIG_H
      #include "config.h"
      #endif

      #include <iostream>
      #include <libfyaml.h>

      int main(int argc, char *argv[])
      {
        std::cout << fy_library_version() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfyaml", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal version.to_s, shell_output("#{testpath}/test").strip
    assert_equal version.to_s, shell_output("#{bin}/fy-tool --version").strip
  end
end