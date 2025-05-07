class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.7.2.tgz"
  sha256 "0c580414f235d99da11e1bfb5bf8dd0ec0cedd8e6d0b5f9c71bb5f6c399a09c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d07209c98c675477f0d718ba43df4616d49e1481b781d97a2a40467adbf9809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d07209c98c675477f0d718ba43df4616d49e1481b781d97a2a40467adbf9809"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d07209c98c675477f0d718ba43df4616d49e1481b781d97a2a40467adbf9809"
    sha256 cellar: :any_skip_relocation, sonoma:        "15e9108f7d86a01e36fc85350a83c9fd7f5a013a86738bf62405b2dff29c9c35"
    sha256 cellar: :any_skip_relocation, ventura:       "15e9108f7d86a01e36fc85350a83c9fd7f5a013a86738bf62405b2dff29c9c35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3b29942c6dcdd70d2438ddd086e4ead479c04707fe232515dd1f8e1894b9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1678bf2265ce36756821b4d0b78134657901f9389a5c19e2e7816807051495"
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