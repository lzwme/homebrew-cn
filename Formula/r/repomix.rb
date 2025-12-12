class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.10.0.tgz"
  sha256 "a081e93c3d0df046a93f5bb7ad7a538d19d7d013767a0a41fa5d2c3e35477f01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ed71216e9cc81574279bb1731ca8acf1fa8cd220603081eaf72469c875695ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed71216e9cc81574279bb1731ca8acf1fa8cd220603081eaf72469c875695ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed71216e9cc81574279bb1731ca8acf1fa8cd220603081eaf72469c875695ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ed71216e9cc81574279bb1731ca8acf1fa8cd220603081eaf72469c875695ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50412ef477205e6f300296a630172bab4050eebd2afe47458aca6872b4575bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50412ef477205e6f300296a630172bab4050eebd2afe47458aca6872b4575bfb"
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