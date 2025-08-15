class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-45.0.9.tgz"
  sha256 "cb0f5611fe2f83d14963bc35f51169e56d5a6d0b45c2438f99005c6b5c342035"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631054b06fb9e37ef14bde74b796dc3c5218b96c9c43f453acb76a716576d469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631054b06fb9e37ef14bde74b796dc3c5218b96c9c43f453acb76a716576d469"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "631054b06fb9e37ef14bde74b796dc3c5218b96c9c43f453acb76a716576d469"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1f61a84ec76f86ba7039968d64ff941cd3d562633f659dd2ae59e7f55e9e21"
    sha256 cellar: :any_skip_relocation, ventura:       "0b1f61a84ec76f86ba7039968d64ff941cd3d562633f659dd2ae59e7f55e9e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f9d045f9bd69593ea327d0578477da9914da74a8e3cdfea5b19711606a304b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "017b28c250d6c1a62dd01da02db6610a0deae28bd5ca0bccac92f94b535c5017"
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