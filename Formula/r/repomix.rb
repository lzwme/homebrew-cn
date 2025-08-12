class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.3.0.tgz"
  sha256 "7e97d2898be74df7ec21faf76e34e5b546dff4246e7895614a1b754abe53cf00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f09b4bc018a7ce50b6c28f5c71f9965692b27caff3f51078af95948ba63afea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f09b4bc018a7ce50b6c28f5c71f9965692b27caff3f51078af95948ba63afea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f09b4bc018a7ce50b6c28f5c71f9965692b27caff3f51078af95948ba63afea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc0183325c179b3263c548d479281a8c8c8719a85e268414714426c406e2f34"
    sha256 cellar: :any_skip_relocation, ventura:       "bcc0183325c179b3263c548d479281a8c8c8719a85e268414714426c406e2f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca624c978c6965dc6da758d342543f6a0fc2bc244987ebf30d18dd13472d19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca624c978c6965dc6da758d342543f6a0fc2bc244987ebf30d18dd13472d19b"
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