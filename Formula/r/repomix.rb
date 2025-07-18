class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.2.0.tgz"
  sha256 "234decc286ee47c950d6802b2aa70f7f8af9aff84e0a24ec52f12f7b346ebf2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fc928c2ce6578a27aa37da052b2d37c99794e2af487accaca715e37e6e7e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fc928c2ce6578a27aa37da052b2d37c99794e2af487accaca715e37e6e7e54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91fc928c2ce6578a27aa37da052b2d37c99794e2af487accaca715e37e6e7e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2739748af14c6a14564c9074cdab596da4fdbfeba69d30eecb1b6a0d61a7771"
    sha256 cellar: :any_skip_relocation, ventura:       "b2739748af14c6a14564c9074cdab596da4fdbfeba69d30eecb1b6a0d61a7771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442b227f39a49071e07ab71d9797ce49bb6df9cbedefd51748997d3b25d62f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442b227f39a49071e07ab71d9797ce49bb6df9cbedefd51748997d3b25d62f1a"
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