require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.1.2.tgz"
  sha256 "e0352683e8a89cc46822d4e99c00d59b1d8309f028cd32c3a2ea559be8bcd443"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f97172df5213bdc2d867bce8448d701cb27ec8cfdfe860c789147ee95dbd6e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872438ba33195247e24a9cd81bbcd1a4496e8c93aad8bd00e2f522c4a9071cda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9afcad556bb2622c6be8afe0a7afbe994d4008bc1af3290d803576c40a6d133a"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5fdd439c179b6b66f0eabb96cffc893eb0fed6b1bce0ca66825007c105d00f"
    sha256 cellar: :any_skip_relocation, monterey:       "fdde8241b6703eddc5b5cd300016198b5df69a57e402384abe15c6caba246eb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "117b5ece60afbbb669b10d780efed041dd37f77ed1ef35fdd9574f03d7d0bb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa1e416f343889783283b7b76e08e1c2e2f99170e0e8ece5467086efc0708e0"
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