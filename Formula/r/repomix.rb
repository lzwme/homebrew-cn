class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.17.tgz"
  sha256 "c6112d3d90eb235f6bdaa7cabad97b4ee1404e442a25d5a4379b3a864518b38f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3690957fdfda3086cb7bd6106a3b4efe29cd317f0492883dab521e65976a0ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3690957fdfda3086cb7bd6106a3b4efe29cd317f0492883dab521e65976a0ad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3690957fdfda3086cb7bd6106a3b4efe29cd317f0492883dab521e65976a0ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c4492073d5eb05a4802bd5381f7697c5d7f1a791260f70c3b7d0c648ec77f2d"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4492073d5eb05a4802bd5381f7697c5d7f1a791260f70c3b7d0c648ec77f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a30b6239720f6e6191b8649ac1702adb75dc7b8234c4745fc8717fca571862"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    clipboardy_fallbacks_dir = libexec"libnode_modules#{name}node_modulesclipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}repomix --version")

    (testpath"test_repo").mkdir
    (testpath"test_repotest_file.txt").write("Test content")

    output = shell_output("#{bin}repomix #{testpath}test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath"repomix-output.txt").read
  end
end