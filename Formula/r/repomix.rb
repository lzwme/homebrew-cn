class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.12.tgz"
  sha256 "c9d9f71c82ef4e8c90948f87634c3d70ccb43c80111100478c9ad8cbe7acc412"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d21b5a94e4c2c2493fdf98e530fdd40022ddf9f8c6db7759f79c31b75d589c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2d21b5a94e4c2c2493fdf98e530fdd40022ddf9f8c6db7759f79c31b75d589c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2d21b5a94e4c2c2493fdf98e530fdd40022ddf9f8c6db7759f79c31b75d589c"
    sha256 cellar: :any_skip_relocation, sonoma:        "af4fd8841c8339566799810148a9c66461f9e5125753fd041509a388ce1ac2bf"
    sha256 cellar: :any_skip_relocation, ventura:       "af4fd8841c8339566799810148a9c66461f9e5125753fd041509a388ce1ac2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff9b616028e29089a6b1efe2bcc1b81cb1eacdaaf4b2aa35694ed819235b852"
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