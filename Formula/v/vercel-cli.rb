require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.7.1.tgz"
  sha256 "71c1b3a897b1e08fd542bd5ff6a4c696e1549135bbfc3ed300be39bfe9f268d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "758adae8b1bdf40d7459e0ca7a70e3f5f71d9c76d27872c7dc954c155f824b81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "758adae8b1bdf40d7459e0ca7a70e3f5f71d9c76d27872c7dc954c155f824b81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "758adae8b1bdf40d7459e0ca7a70e3f5f71d9c76d27872c7dc954c155f824b81"
    sha256 cellar: :any_skip_relocation, sonoma:         "b762aef003714135dc6a5d88ec02c234d904d10b03f9e3db8611b978eb3a8ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "b762aef003714135dc6a5d88ec02c234d904d10b03f9e3db8611b978eb3a8ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "b762aef003714135dc6a5d88ec02c234d904d10b03f9e3db8611b978eb3a8ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f724183d4b72897e524f89b9f38ece95f9062bac340496e33cbcdb1d3bf4d5fa"
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