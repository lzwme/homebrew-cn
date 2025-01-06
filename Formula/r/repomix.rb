class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.16.tgz"
  sha256 "6e418b357285ab103eb5cb504881e18e57f14eeff14c18c12cfad8e14886e57e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5397e55b51f5773ed0cca19dfb78f2acb04e001966137adf12b3c11370ca51f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5397e55b51f5773ed0cca19dfb78f2acb04e001966137adf12b3c11370ca51f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5397e55b51f5773ed0cca19dfb78f2acb04e001966137adf12b3c11370ca51f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "97f4e44260bf1a671a994ad797e256b3bb208632f2914fc5d37806512f08b47e"
    sha256 cellar: :any_skip_relocation, ventura:       "97f4e44260bf1a671a994ad797e256b3bb208632f2914fc5d37806512f08b47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527dab7f07d17216e33d5b3e0ca50d89296acb98183eeeaa6d7a3e467c4bd3c3"
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