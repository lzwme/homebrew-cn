class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.4.1.tgz"
  sha256 "e98ba4eeb4f6e14a6b5ef392448d7408c47244f56893844693483b605ab68f9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcf0fc4ef21a424637156a0f2d7c1f91e68d6be1d43d278ca28b04804c822b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fcf0fc4ef21a424637156a0f2d7c1f91e68d6be1d43d278ca28b04804c822b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fcf0fc4ef21a424637156a0f2d7c1f91e68d6be1d43d278ca28b04804c822b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fcf0fc4ef21a424637156a0f2d7c1f91e68d6be1d43d278ca28b04804c822b7"
    sha256 cellar: :any_skip_relocation, ventura:       "9fcf0fc4ef21a424637156a0f2d7c1f91e68d6be1d43d278ca28b04804c822b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3be92c410724a0d1686eeb1a1111050adfc093c5feb8f910aed94e416a280d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be92c410724a0d1686eeb1a1111050adfc093c5feb8f910aed94e416a280d5f"
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