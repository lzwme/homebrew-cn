class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.10.tgz"
  sha256 "72cb819188c6e828ced895b1b9af507ec93d0d09fde27d2d49277b252e2466b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7df9df0420067ef1317f99de09a685c25dce403dc8b40950bc6dcb06f55ad6c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df9df0420067ef1317f99de09a685c25dce403dc8b40950bc6dcb06f55ad6c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7df9df0420067ef1317f99de09a685c25dce403dc8b40950bc6dcb06f55ad6c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e474c0cac8e43352177984c3a404f1d5b24814d50e6a8de290b2dc1f6015d78b"
    sha256 cellar: :any_skip_relocation, ventura:       "e474c0cac8e43352177984c3a404f1d5b24814d50e6a8de290b2dc1f6015d78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52634ef434170ce95c8b17f543e187efafc789eb5d8b0c1a4db94f863e55f9e0"
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