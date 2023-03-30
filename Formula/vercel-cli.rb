require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.18.3.tgz"
  sha256 "841110f6fd45e6f22046e3a7d6daaa527c98d0581d95c2593cd4f11f3ca60a6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8b948a2ba94f10fc8df508ba207089e54d48ea6aec810b775351cac02d04941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "194868bcdfa0394d84dfc21fd2478d945398933c5a30ce8160ad7562f39591e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07305e2eb6bafd3f8e21824aa38548bab3a7a06b916cfc8277a28283ec16c508"
    sha256 cellar: :any_skip_relocation, ventura:        "52e6a18025fa3fb85e497dfbd2893fba1cd2e68f83e787093d0de6925ab442ff"
    sha256 cellar: :any_skip_relocation, monterey:       "40c36519c32f39cff38ee49868a0aca882912c8485e9b9508c4529b0b745a1e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c2f2bdf57132e6b07df2eb1ebec8a384784b8fb79bd495ac936f2938d40336a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ecc7cb1d817812f352fb39c574d5f78a1866bdca132a329482032172cedced6"
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