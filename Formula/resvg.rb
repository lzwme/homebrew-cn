class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://ghproxy.com/https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "134bf993de98566239ea9a0bd917e0e7f0c4041604cd28e7e91bf5a0d68018ca"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c923f6a60c123bb6948a7883de9489ee7aa143cea763ce7e72bb7d6277053976"
    sha256 cellar: :any,                 arm64_monterey: "7b20cf68c11e4cb91e4fa0795902e2575a239ec649e4784b3437f24b2cebe6d4"
    sha256 cellar: :any,                 arm64_big_sur:  "8c283344dce76359120bf33e985e32a1fbac9690038b0c796a9c92ec9a141444"
    sha256 cellar: :any,                 ventura:        "73e2d6a0f1450e10140ec1c36f47edb25097f6e3cbf0060677a212d2d83be671"
    sha256 cellar: :any,                 monterey:       "81eadeb015dceef047d471fb297e1299aab2e55177200cd1923b1990a049e2ac"
    sha256 cellar: :any,                 big_sur:        "f2afb8960fab2fdfd93bf1a035fef265b7eaf4ba73cd7786066113ea10cb14c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a1c7f0cc36c1e018a794af623bbd916f44876fc9a9cf663d11b2f874e543d69"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/usvg")
    system "cargo", "install", *std_cargo_args(path: "crates/resvg")

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "crates/c-api/Cargo.toml", "--release"
    include.install "crates/c-api/resvg.h", "crates/c-api/ResvgQt.h"
    lib.install "target/release/#{shared_library("libresvg")}", "target/release/libresvg.a"
  end

  test do
    (testpath/"circle.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    EOS

    system bin/"resvg", testpath/"circle.svg", testpath/"test.png"
    assert_predicate testpath/"test.png", :exist?

    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_predicate testpath/"test.svg", :exist?

    (testpath/"test.c").write <<~EOS
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
    assert_equal "160 35", shell_output("./test #{test_fixtures("test.svg")}").chomp
  end
end