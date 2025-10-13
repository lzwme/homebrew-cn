class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.7.0.tgz"
  sha256 "bbc1a5a3e04520e903ac166868a27c7a96121d7bbdcad43fde27f9053cc5dde4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d066bfee68bfa0901db144e75bcc1adf176587a2f873c65065f377e380e3d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d066bfee68bfa0901db144e75bcc1adf176587a2f873c65065f377e380e3d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d066bfee68bfa0901db144e75bcc1adf176587a2f873c65065f377e380e3d44"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d066bfee68bfa0901db144e75bcc1adf176587a2f873c65065f377e380e3d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d4712727dea8df2c6b5010053cf8cb570448bd0335ca32841ae08a3efd5cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d4712727dea8df2c6b5010053cf8cb570448bd0335ca32841ae08a3efd5cd5"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end