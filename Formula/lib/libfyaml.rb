class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://ghfast.top/https://github.com/pantoniou/libfyaml/releases/download/v0.9.2/libfyaml-0.9.2.tar.gz"
  sha256 "d76da1dcc91f5d74cb9812ecce141477be93a258001e05a268a86715c0eea098"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec40fa5cfa28199daf08a21ecb57d7e1d0937c39e29b292721dad1c6e8b94661"
    sha256 cellar: :any,                 arm64_sequoia: "b8a7731d03b6dd7e0e327b316974dd5aa3a6845ca2d38d81ac42406ca4244315"
    sha256 cellar: :any,                 arm64_sonoma:  "2e13376d69d9d2550d3419d5e91dee57e60e87f1d30d328fe32deb1490760a36"
    sha256 cellar: :any,                 sonoma:        "31d12784eae3f32f18e808ce66fd14e79acffde46cbaf42bfacdd25daa5b92e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf91c5cd0b358fb56a38cc8876b4bd16f4a0d42d339911e441379455e92e4b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16791920f201ffa6465fbbadfd0226eac75e5a5a0e1c983b85a59b6fbcf07d07"
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