require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.5.6.tgz"
  sha256 "e127bb4f6fa6b97aac9b68b462d3965004da69b93efae48eeea7f0ef886050f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d44e541046281a776be32d98e5eeaa1541c933e0699adfce27e5d10d8e520e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d44e541046281a776be32d98e5eeaa1541c933e0699adfce27e5d10d8e520e84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d44e541046281a776be32d98e5eeaa1541c933e0699adfce27e5d10d8e520e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "7acd4758786212c4186ac12294c7787bd0ffdc4a54aaad2bad8fface61c860c2"
    sha256 cellar: :any_skip_relocation, ventura:        "7acd4758786212c4186ac12294c7787bd0ffdc4a54aaad2bad8fface61c860c2"
    sha256 cellar: :any_skip_relocation, monterey:       "7acd4758786212c4186ac12294c7787bd0ffdc4a54aaad2bad8fface61c860c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05b5a803f17c7b9bf530bda9580ea8f28a53abe78a7f4139115076e18e73b14d"
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