class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.3.9.tgz"
  sha256 "abf7dc2d7a0eca89c6ce7bcaba41acaf2ba758fbb1025d02b29704f06ddd0067"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f34712a971fcf236c7b1ae7f22e522193ff18ce1a0cf2fc12104ddd9ca59fb0"
    sha256 cellar: :any,                 arm64_sonoma:  "6f34712a971fcf236c7b1ae7f22e522193ff18ce1a0cf2fc12104ddd9ca59fb0"
    sha256 cellar: :any,                 arm64_ventura: "6f34712a971fcf236c7b1ae7f22e522193ff18ce1a0cf2fc12104ddd9ca59fb0"
    sha256 cellar: :any,                 sonoma:        "d974168dc3ec66619556fab0b703127f1ae54f796be44782447c6120a057a9a4"
    sha256 cellar: :any,                 ventura:       "d974168dc3ec66619556fab0b703127f1ae54f796be44782447c6120a057a9a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eddc4d6d24cae9714dac97fbf06de73c31e32dfe79ed087b37a8599b6357f5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f518881f5570b6f6ad72d41d496af13c7bd410f447bd8c26bbe9fe135884af5"
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