class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https:github.comRazrFalconresvg"
  url "https:github.comRazrFalconresvgarchiverefstagsv0.38.0.tar.gz"
  sha256 "cdb306f62c55e06aa1071323e7dcd72e5f5d63210af108dd74549937a22bd2d2"
  license "MPL-2.0"
  head "https:github.comRazrFalconresvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2964869e391e26ae68a2753750feca5de9be5a703e600c683c81d935c5f2a77"
    sha256 cellar: :any,                 arm64_ventura:  "54e114963fa6f5c7d2ea784af11dbe6dac29e46191729370303b904234cc5f93"
    sha256 cellar: :any,                 arm64_monterey: "ae849ab4696f58451342420a1263a95b434d4410b964dab72fb659921f80c5f4"
    sha256 cellar: :any,                 sonoma:         "56dddd9c162501d2134fc5b19c6654cdb9c24250eda9f6de8274a368144e0397"
    sha256 cellar: :any,                 ventura:        "c91cbd08fe571636e1ee6db15a13e54ce121d4722e6cac3c8e65741717bc9515"
    sha256 cellar: :any,                 monterey:       "ef6a5e46053901387e475eced41fe556510d66be05ace71ae4578a3ea2dce21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e5cde06dd6adab604c94085c50ad5d14c47b1966df743858d5773aa6eff20f"
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