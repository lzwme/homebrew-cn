require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.19.0.tgz"
  sha256 "889053194b5938468ea36afe9a228e43d83a5c0c6c88e985610059a4d6c346d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "725cbd1bdc2d54ca1a8d5a8b00e5c4ea7970b2aaa1b6fa2016a13b4ab28d66f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6f1037ed1f1bda0adf0c35b331966d5f8e69b64cef0416e748b06900e16bf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c27bfbf74a3c2a9c4d428366082bd73c2848e81e2bdabb271e2d36d91638be0d"
    sha256 cellar: :any_skip_relocation, ventura:        "cd8e9251667b9226645e3e1e538eee4560418d633c4522e76fee8a5e120f23da"
    sha256 cellar: :any_skip_relocation, monterey:       "712124eee7fbb79e3affbb0fb24ec15a43191c345c7b1e29f583c937ecc02e4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcd235341b204dcbb4d06dca8bfe63e5bf5005a1a0362506b41e76d9cf0e0de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13de9f4b0452cf9be49168aad6fc57d55d3053f0b02b2ee40bc882520dfa859"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end