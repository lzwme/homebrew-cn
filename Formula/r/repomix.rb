class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.29.tgz"
  sha256 "b537ab2c2336bbe2de8bd3f32df6368ed4a2aa4e763f2cf899c3c5ffb25f1065"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0412f25d5d444fe0df58b0d1f31879b0b72c8dc1f1cb6c404bad20815108d571"
    sha256 cellar: :any,                 arm64_sonoma:  "0412f25d5d444fe0df58b0d1f31879b0b72c8dc1f1cb6c404bad20815108d571"
    sha256 cellar: :any,                 arm64_ventura: "0412f25d5d444fe0df58b0d1f31879b0b72c8dc1f1cb6c404bad20815108d571"
    sha256 cellar: :any,                 sonoma:        "c77d40e1b510a6185babed9072207edd85b7e8bb3e58fb4356c2d8e5330528b4"
    sha256 cellar: :any,                 ventura:       "c77d40e1b510a6185babed9072207edd85b7e8bb3e58fb4356c2d8e5330528b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c11355d2668a5ac49fe162497780ca2548bca19cefca4dbdb3818617436cea3"
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