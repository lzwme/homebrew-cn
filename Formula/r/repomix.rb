class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.41.tgz"
  sha256 "dd4661a72003640d4f1e8afa7a6b9e7f44243a1d6bda9c9748d5a5c194129f47"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0ad5d0f5ae9827f4cb95ef312743d0615fbf18698b9699e75248887d5a33cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "f0ad5d0f5ae9827f4cb95ef312743d0615fbf18698b9699e75248887d5a33cf9"
    sha256 cellar: :any,                 arm64_ventura: "f0ad5d0f5ae9827f4cb95ef312743d0615fbf18698b9699e75248887d5a33cf9"
    sha256 cellar: :any,                 sonoma:        "841e9b8f19d8b4c57d1eda15f1d06f6b8cd855b243645b147e74c91f8cb786cc"
    sha256 cellar: :any,                 ventura:       "841e9b8f19d8b4c57d1eda15f1d06f6b8cd855b243645b147e74c91f8cb786cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15ee53e17d412658431aba5bc04f5f0983912291e79f99fa985b733750e33833"
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