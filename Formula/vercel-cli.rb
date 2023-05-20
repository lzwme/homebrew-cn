require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.3.6.tgz"
  sha256 "a641103e21d2ef7aab9ca129778da1208327d8d4f593e5d56ae53c0a4275add3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa07bcf046ba0746d0094863cf5bf7de0cb385b58eef6dd5fac4e001368a085c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c3e217a46b46710f1dacbee26cc8c9ca1a60db51a4b27016dd8d8f2f3c8af1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b5acecab683b72d709fde6444c71534ccbca4e07966f7568fab923465ba3597"
    sha256 cellar: :any_skip_relocation, ventura:        "a0979c4b43eb7d8be6553354666a7a7d43d32bdd48ea7f57eef04a86d18e33b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4e96c43f86fcad365ce23ff49324fccb69a99ee201e243a2fc52751f7ae0b2ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff98d543acc1dde1fe6349bf364547087ccca616239da06df88bb82e794d9b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4999c2a1ca90dd07f4fbd0d83ecfe34abc067fd2f6dbf332bfacca818cc2a49"
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