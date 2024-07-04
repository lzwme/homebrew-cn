require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.3.0.tgz"
  sha256 "015a4b4ed8d42ece037ecddf717cab74e86d968895aa0b670b83d1b77394ff95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2c1d5626e9614d3a2f193878291291ac1a530afaae2b5d849f67de786bf8a9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2c1d5626e9614d3a2f193878291291ac1a530afaae2b5d849f67de786bf8a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c1d5626e9614d3a2f193878291291ac1a530afaae2b5d849f67de786bf8a9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4068d5fb9b499c2a761c64819246fe4ef83d11e97695c5b2b4168e1ab12f2a62"
    sha256 cellar: :any_skip_relocation, ventura:        "4068d5fb9b499c2a761c64819246fe4ef83d11e97695c5b2b4168e1ab12f2a62"
    sha256 cellar: :any_skip_relocation, monterey:       "4068d5fb9b499c2a761c64819246fe4ef83d11e97695c5b2b4168e1ab12f2a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6410cead75bc581b61fb7e60a6fe21d24c41eca3cc79b58a3d77ca37fd1eaa"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end