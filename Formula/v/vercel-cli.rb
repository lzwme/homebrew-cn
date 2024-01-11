require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.1.0.tgz"
  sha256 "5662c2a3678f03ec95f049b67b311cc23e510b14bef50a54a52462a218cdd956"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a736704079964cdf0e424ae76523cc27ddab68e3ac347193c9f0f709672cb41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a736704079964cdf0e424ae76523cc27ddab68e3ac347193c9f0f709672cb41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a736704079964cdf0e424ae76523cc27ddab68e3ac347193c9f0f709672cb41"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea5544f3ffc7de502a9f7629d4b0420fb3eae4de436c01d116741f9c8dae7d24"
    sha256 cellar: :any_skip_relocation, ventura:        "ea5544f3ffc7de502a9f7629d4b0420fb3eae4de436c01d116741f9c8dae7d24"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5544f3ffc7de502a9f7629d4b0420fb3eae4de436c01d116741f9c8dae7d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f8bc746787f4c4c79e56391e09b3a861fd2caf4b6868a7f44897f96a71447f"
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

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end