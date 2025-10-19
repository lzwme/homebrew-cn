class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.8.0.tgz"
  sha256 "82b8cc0e1ba5d249544de5e1b12be43dcf782128f1d1c6ff9bc10560595f01c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3d00ee6340fcfa795c0ed81477e34afe1710d8843499900e6581b2fe5419b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d00ee6340fcfa795c0ed81477e34afe1710d8843499900e6581b2fe5419b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d00ee6340fcfa795c0ed81477e34afe1710d8843499900e6581b2fe5419b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d00ee6340fcfa795c0ed81477e34afe1710d8843499900e6581b2fe5419b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "780839c423b17b9f94775633803984970d1976dd299405baa05696b26c8b26c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "780839c423b17b9f94775633803984970d1976dd299405baa05696b26c8b26c6"
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