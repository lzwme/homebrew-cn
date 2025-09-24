class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.4.tgz"
  sha256 "56fbe870f702830a9782ac09e901f2c65c6457f642a7fe0607252d839a02b822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85de5043dde2172b4f83b3df3c5043f6c067aac0caa5cb1a6b6c0358595eef83"
    sha256 cellar: :any,                 arm64_sequoia: "a9032c17301a99f6c788f80b956e5590bf9e4e434b3f5c6ec61e16501561ff25"
    sha256 cellar: :any,                 arm64_sonoma:  "a9032c17301a99f6c788f80b956e5590bf9e4e434b3f5c6ec61e16501561ff25"
    sha256 cellar: :any,                 sonoma:        "19e2a77cae69f43f03f327c07bcc6d786fc9ebcc59c714c0668ad2430cd2917e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c53434772506d942a67743410ba86d0467d71afa3f763f05f31c3a7f9a53298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f1e63a2f92666f6746aeb1271e8f363259ed1e8de2a528ebcb2c7b4238de8f"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end