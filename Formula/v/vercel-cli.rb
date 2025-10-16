class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.3.0.tgz"
  sha256 "8dc44030b99f48cfe2a42486111b4afd9189204baf4a33962a904e9bf6bd5a5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd0240262893daab19b157124bf6136e9fe138151715add553b6b7b7bd57e8bf"
    sha256 cellar: :any,                 arm64_sequoia: "7bd41d96f629229ac0f79f3e57cacb287e78d5470d0af63279f671e17b64fc0f"
    sha256 cellar: :any,                 arm64_sonoma:  "7bd41d96f629229ac0f79f3e57cacb287e78d5470d0af63279f671e17b64fc0f"
    sha256 cellar: :any,                 sonoma:        "01ddec11ae419e8e7f401d2fd087bcc020fde9c03f1275a3a8ceecca96074d3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "406d4d90a8b57a11e05ca9e1cc6d66e80ab9b1ff6831627c2d2c7207e2e22289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c5a7189b8ec6a34ca944986c7b4de643eee8159937981c1a8d76961c457a8fe"
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