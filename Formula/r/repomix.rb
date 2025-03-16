class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.40.tgz"
  sha256 "6e87408b5ec2a74611786cd38ef00efae3642ba560b4fafc7d4f1d313e28c539"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6466a3e94bf1f602a71cc394ddd670d80784c513b45da293b14aa96cef3a094"
    sha256 cellar: :any,                 arm64_sonoma:  "c6466a3e94bf1f602a71cc394ddd670d80784c513b45da293b14aa96cef3a094"
    sha256 cellar: :any,                 arm64_ventura: "c6466a3e94bf1f602a71cc394ddd670d80784c513b45da293b14aa96cef3a094"
    sha256 cellar: :any,                 sonoma:        "2a4809a19b371f316350af383fa0d95f78929bbe1f1e7e1d1eed46b847609f1c"
    sha256 cellar: :any,                 ventura:       "2a4809a19b371f316350af383fa0d95f78929bbe1f1e7e1d1eed46b847609f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7c10cec8805e0d83a813fa4098b2354779aa30e8965357a4b8a50fec479fc8"
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