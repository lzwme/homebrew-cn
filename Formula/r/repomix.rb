class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.3.5.tgz"
  sha256 "59572010f92af2cf03abb553e6e58754bf5f64cbf45c9ee2f304581dff0de3f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9098cc7d89f0e4533377e8922f56732721bac01332f1c4dd4c1f0b01d8239a4d"
    sha256 cellar: :any,                 arm64_sonoma:  "9098cc7d89f0e4533377e8922f56732721bac01332f1c4dd4c1f0b01d8239a4d"
    sha256 cellar: :any,                 arm64_ventura: "9098cc7d89f0e4533377e8922f56732721bac01332f1c4dd4c1f0b01d8239a4d"
    sha256 cellar: :any,                 sonoma:        "e1ff9033bb637b42cd6dc0a78f56406bf8541f92e4b811321caaebb863b48255"
    sha256 cellar: :any,                 ventura:       "e1ff9033bb637b42cd6dc0a78f56406bf8541f92e4b811321caaebb863b48255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4316baec823d6b9ad195d20a19da2e2bcde63a73885f5a783fdfba6e9735b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c64cd8b0731ab32e9b98105c9b251b28b12ecd3bbe59e0545b4d9ca0297d578b"
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