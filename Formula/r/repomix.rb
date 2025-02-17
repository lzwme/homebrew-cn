class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.28.tgz"
  sha256 "91c0bf837790dd489b2f3c46ce9e2d31d7dab04a9dbe083f81c9408c5d815828"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a5d447b223518064ccea13d47beaceff367e736ec32b0b89ebd3e41fd809766"
    sha256 cellar: :any,                 arm64_sonoma:  "9a5d447b223518064ccea13d47beaceff367e736ec32b0b89ebd3e41fd809766"
    sha256 cellar: :any,                 arm64_ventura: "9a5d447b223518064ccea13d47beaceff367e736ec32b0b89ebd3e41fd809766"
    sha256 cellar: :any,                 sonoma:        "3ae551977b3a6376f6850c9a89e57971309a73cca69d6e8db2ffd85f93e066a6"
    sha256 cellar: :any,                 ventura:       "3ae551977b3a6376f6850c9a89e57971309a73cca69d6e8db2ffd85f93e066a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f74b34e72932ca1ae6777c66fc9d262f9ff9d980d4e2dccfccbefa1bb90d3ee"
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