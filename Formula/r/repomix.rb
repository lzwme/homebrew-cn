class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.15.tgz"
  sha256 "f4250a0d2f248550d1dbf1a30a116b6644046c3640747d6930a40b8076754bc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c9e9725fc574230cda758edb9f74c9e82ff0ab80bb09ea81c34d24f8807b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78c9e9725fc574230cda758edb9f74c9e82ff0ab80bb09ea81c34d24f8807b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78c9e9725fc574230cda758edb9f74c9e82ff0ab80bb09ea81c34d24f8807b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "81483f1bf2aff2ac615f911e29766e409a0d6c6a7b90f8f44dd4c86ad28e367c"
    sha256 cellar: :any_skip_relocation, ventura:       "81483f1bf2aff2ac615f911e29766e409a0d6c6a7b90f8f44dd4c86ad28e367c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebff89c0be9873d683ead8b802ef57eef1fe661e2fe092893c27fd760efb73d"
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