class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https:github.comRazrFalconresvg"
  url "https:github.comRazrFalconresvgarchiverefstagsv0.39.0.tar.gz"
  sha256 "a0391d7ca3fa0a33e7c6e8f11bfa955231eba2820a4e06bddb464076491defa3"
  license "MPL-2.0"
  head "https:github.comRazrFalconresvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4a283be7369736992e3558ebfdb7d19583db130bc0c94d8b76c077ff067d993"
    sha256 cellar: :any,                 arm64_ventura:  "92a8a29fe6eab009c61d941c25601b0d7a0a4e1fb2c04c49713ef820790e782c"
    sha256 cellar: :any,                 arm64_monterey: "7a7eeab8bb03e06bf2b8f7c276a891c9def7deb68661950e85b8075b24118e82"
    sha256 cellar: :any,                 sonoma:         "d331201229ad37c8385a2593fcd36b770666260c23334dcec9a938c31769c805"
    sha256 cellar: :any,                 ventura:        "cdabd3d89b76d405ec7f6c3f1da6986e20829543405c12bae64cdbcc38058189"
    sha256 cellar: :any,                 monterey:       "265f4e10ed450cb9756d607eeed5f0a8a069b50931a54e9687c07b73ba41220d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8d67c387916b32538ce5616662319270f0173f325c4abed33f736ee57ca8cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesusvg")
    system "cargo", "install", *std_cargo_args(path: "cratesresvg")

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "cratesc-apiCargo.toml", "--release"
    include.install "cratesc-apiresvg.h", "cratesc-apiResvgQt.h"
    lib.install "targetrelease#{shared_library("libresvg")}", "targetreleaselibresvg.a"
  end

  test do
    (testpath"circle.svg").write <<~EOS
      <svg xmlns="http:www.w3.org2000svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" >
      <svg>
    EOS

    system bin"resvg", testpath"circle.svg", testpath"test.png"
    assert_predicate testpath"test.png", :exist?

    system bin"usvg", testpath"circle.svg", testpath"test.svg"
    assert_predicate testpath"test.svg", :exist?

    (testpath"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <resvg.h>

      int main(int argc, char **argv) {
        resvg_init_log();
        resvg_options *opt = resvg_options_create();
        resvg_options_load_system_fonts(opt);

        resvg_render_tree *tree;
        int err = resvg_parse_tree_from_file(argv[1], opt, &tree);
        resvg_options_destroy(opt);
        if (err != RESVG_OK) {
            printf("Error id: %i\\n", err);
            abort();
        }

        resvg_size size = resvg_get_image_size(tree);
        int width = (int)size.width;
        int height = (int)size.height;

        printf("%d %d\\n", width, height);
        resvg_tree_destroy(tree);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lresvg", "-o", "test"
    assert_equal "160 35", shell_output(".test #{test_fixtures("test.svg")}").chomp
  end
end