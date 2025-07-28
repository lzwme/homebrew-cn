class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.2.1.tgz"
  sha256 "40252730f4c04edf811146e98fd49d203b090701a71ddf15dab26a666d47923b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d472300724ff93d67b867cf36fe39b2530246fc09c89da1d565ad17e06827ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d472300724ff93d67b867cf36fe39b2530246fc09c89da1d565ad17e06827ffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d472300724ff93d67b867cf36fe39b2530246fc09c89da1d565ad17e06827ffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca7f60b335adb6371e63f574c3994a38e7e4fdb19bbfb2e21aa6ccc5be0415aa"
    sha256 cellar: :any_skip_relocation, ventura:       "ca7f60b335adb6371e63f574c3994a38e7e4fdb19bbfb2e21aa6ccc5be0415aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec95db568d289639af503f4d91eaf2868a1bb285372c5845cab836c523ac5a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec95db568d289639af503f4d91eaf2868a1bb285372c5845cab836c523ac5a9b"
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