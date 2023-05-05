require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.1.1.tgz"
  sha256 "28b547c60db5fa5dc6b3c6fc57a890beb0fe85037ac022f878d2816081a27971"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "315900aeb503812e13f0911537b5317da072d6ee02783fc4db172ba3fd7be5b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f96e72d4733f741dfa49c641e4b0980738ef00ddbe353ed6ffe6fe66dd707a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d824a7aa0f3282fca68d3909459ae3cc4a3c1bb8883c5ff81a392f15e13c6fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "438c40c66fa1493405d77026f104d16bd3ed39d9365eebb6b5583d74921711e9"
    sha256 cellar: :any_skip_relocation, monterey:       "5754e89ac2f15ea976d2b5f6e7cd2495c87fec21d6c5537c1af34d78e54ee1b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9eccd13a1e4b55dae5a9856c13d91c6249431968d110531c86611150a8eec553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e779a1662dd0189e4f80e010a5dee2f0573f49b64cfcd7b24e75f4264fb226bd"
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