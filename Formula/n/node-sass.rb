class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.105.0.tgz"
  sha256 "f33df7a56f3c3687b7c781f92d9f79a496cc659e51a493c0862ec0102e8ac56f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f761fb53692018b015ba3d5ff9d881e7e148bee2dacb5564330d4c057b171113"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f761fb53692018b015ba3d5ff9d881e7e148bee2dacb5564330d4c057b171113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f761fb53692018b015ba3d5ff9d881e7e148bee2dacb5564330d4c057b171113"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8feb20952bc807e0fdf27175cdad8e43d334d2b290afe0aec471ccda09adf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "04218e4700e5a4a0fea9ab717919d8dc72c815b9efb49d015ef6564066373dad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end