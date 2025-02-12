class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.26.tgz"
  sha256 "2be6a218bd980b3007f2650f58d6f6736e5b31e226356bc0366eec8ce23e2f80"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4599c930ce2876055af758d2ccde39401684fa5439bcbb3959d5fb87628d02ba"
    sha256 cellar: :any,                 arm64_sonoma:  "4599c930ce2876055af758d2ccde39401684fa5439bcbb3959d5fb87628d02ba"
    sha256 cellar: :any,                 arm64_ventura: "4599c930ce2876055af758d2ccde39401684fa5439bcbb3959d5fb87628d02ba"
    sha256 cellar: :any,                 sonoma:        "54dc49b8104fbb6587955b9a5c0a4c20a7541cad11c26a3f50a28b442afa1ade"
    sha256 cellar: :any,                 ventura:       "54dc49b8104fbb6587955b9a5c0a4c20a7541cad11c26a3f50a28b442afa1ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34127b76854d352a77286470d6845651c3157d65e78e6e79b300c61e6d6fbbed"
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