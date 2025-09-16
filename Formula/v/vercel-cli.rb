class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.0.1.tgz"
  sha256 "5f200df8ed588316a694f7e6f787ae6a18b6bc52241147deeef110ea72c08745"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51dcd1ed37f72e2e27ca4b2f960efc6f0ae6d0014dc6c1b65669e3ca55e7e73d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51dcd1ed37f72e2e27ca4b2f960efc6f0ae6d0014dc6c1b65669e3ca55e7e73d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51dcd1ed37f72e2e27ca4b2f960efc6f0ae6d0014dc6c1b65669e3ca55e7e73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "753270ef012885d6b1e48af2fcd803d4355542a2e050ee0455ea5b17759191bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11916df77a8cc1e4a9b2f9441570ad564365b9cf2ac1f24be25b192f7e503765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "079c85db82cef8fa9e79fe46da75eeda962a580a47619396de78b14de53a5b8b"
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