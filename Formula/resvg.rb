class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://ghproxy.com/https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "a2f09d00e4e0d689c72924dac46aa21371e89c751344051ead08397e2cf644c8"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22db6e394dc3983de7aa0a52095666e0ea78b7a43361f15d27c075d8afac4361"
    sha256 cellar: :any,                 arm64_monterey: "05f93bded4aa86d08e1f93b6fb3967dd065a3987d85f919147720a0544496adb"
    sha256 cellar: :any,                 arm64_big_sur:  "1a77813a961a7b2df65ad4187c343ff85fdd94a3dd9c19307c9de0fac59d95b2"
    sha256 cellar: :any,                 ventura:        "6ca7dddc6489eaa0f13d90022e255a0cadaf174af8995a639d87b9b1ed92f502"
    sha256 cellar: :any,                 monterey:       "168f8e35a29b34eb6604dc979b529f139ac7b5593adcedbcacea6d1b3d7290f3"
    sha256 cellar: :any,                 big_sur:        "49cea615fbbd8545fd2e54bb6352749c6c22b44bbd8790f854e364cfa3b1be87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9334e09fbbb2f3d574a7bb0dc2d483858f3e0f0d0b8b75b7aa0cdd2e989f3945"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "usvg")
    system "cargo", "install", *std_cargo_args

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "c-api/Cargo.toml", "--release"
    include.install "c-api/resvg.h", "c-api/ResvgQt.h"
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