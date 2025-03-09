class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.35.tgz"
  sha256 "714eddc39d78f4fc134016698df5d9a2a6296b28b02e846eae9db3c475ecdd09"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98cb5f80f269a34ff1e2d38dfaa1e118ed4bb7b90218a22f765ce50b7d6e817e"
    sha256 cellar: :any,                 arm64_sonoma:  "98cb5f80f269a34ff1e2d38dfaa1e118ed4bb7b90218a22f765ce50b7d6e817e"
    sha256 cellar: :any,                 arm64_ventura: "98cb5f80f269a34ff1e2d38dfaa1e118ed4bb7b90218a22f765ce50b7d6e817e"
    sha256 cellar: :any,                 sonoma:        "b93d6aa5ca32d441503a5904bb75aa1ca5576198ebe7a950decaa889688c17dd"
    sha256 cellar: :any,                 ventura:       "b93d6aa5ca32d441503a5904bb75aa1ca5576198ebe7a950decaa889688c17dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4aed82d02c6282d1a165605b99041a6a38a6b9de30c06b9882e26d4dab0f675"
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