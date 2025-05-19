class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.3.6.tgz"
  sha256 "a631989af4463a4a274b9df9a1732fa9a62ac005f7e3018f538f26d0892ae3d6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9763b3a5c95f0b13eb61846e5cc79e6c5a2e6d31734121f0d62dd7f44a8749ac"
    sha256 cellar: :any,                 arm64_sonoma:  "9763b3a5c95f0b13eb61846e5cc79e6c5a2e6d31734121f0d62dd7f44a8749ac"
    sha256 cellar: :any,                 arm64_ventura: "9763b3a5c95f0b13eb61846e5cc79e6c5a2e6d31734121f0d62dd7f44a8749ac"
    sha256 cellar: :any,                 sonoma:        "48ebfd63bacb163bc41207ab6dc0a568f4b7de9e6e8c6f4070e5cf47112ec8f5"
    sha256 cellar: :any,                 ventura:       "48ebfd63bacb163bc41207ab6dc0a568f4b7de9e6e8c6f4070e5cf47112ec8f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3554fd97587de9024651970a91ae4cee860058bd84d79ee7e3174ec3dba8ede8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a08a5ef725c3cafdc585e8ffc64b6e248e3c66d5b832a04198bf54e8f20aac"
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

    output = shell_output("#{bin}repomix --style plain --compress #{testpath}test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath"repomix-output.txt").read
  end
end