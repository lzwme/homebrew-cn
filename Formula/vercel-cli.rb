require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.0.2.tgz"
  sha256 "1f762fcf7b6014e41219240e4f1f8a95f72c8bb29e03b3f2d212c62e1b20ebe1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e03d0f12d561a8bd508a7492633e47f5e3b55cffd6279d0f87e946eff2e7971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73bf6b8b672d26a4cc6974b5bd4d94e8f958abad74ad3d7099f3119ffb77d4d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f8e11550fc595027380e4f87650f41987e06543c8b257cbf7cb64218a1ff67"
    sha256 cellar: :any_skip_relocation, ventura:        "eeea853b55bfa172036dd2a80b740d09a6b6475f391ad30a3f5358b19338d3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "33621bdd1be526123571efb54bcccc406cf4afc6ceca93c9bb0b69d2bb00300f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1495a733ee73fab74fb73719bf68407ef9ddfd01d4e9213c4d62cd336ed3cc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3867f7bc7a9eaa638eb5de62101ad5fcfc109853fc8ac91331a0941d37662022"
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