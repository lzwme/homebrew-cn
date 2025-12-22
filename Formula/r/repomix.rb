class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.11.0.tgz"
  sha256 "dda6bf810406159093a96b82d9277fcaa9e4235511814ae7ce62e02e624e32fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6b83c5c1e6e6d80c4ceb02abfba9747e30d5640ffddcaf855c17c9e5ca5cc2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b83c5c1e6e6d80c4ceb02abfba9747e30d5640ffddcaf855c17c9e5ca5cc2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b83c5c1e6e6d80c4ceb02abfba9747e30d5640ffddcaf855c17c9e5ca5cc2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b83c5c1e6e6d80c4ceb02abfba9747e30d5640ffddcaf855c17c9e5ca5cc2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f411c064ac189b5393af4273f62c11383e7f2302443bacf2aa8da83fd653e1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f411c064ac189b5393af4273f62c11383e7f2302443bacf2aa8da83fd653e1eb"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end