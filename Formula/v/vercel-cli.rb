require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.0.2.tgz"
  sha256 "75c5acd591ff6af4e81446f24237a4efef683493792c466edc7840734d5936c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64da531621d1a67d3a2e6b2dd51c1ccf0f87a38726341decbdff5c60cd0b1dbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64da531621d1a67d3a2e6b2dd51c1ccf0f87a38726341decbdff5c60cd0b1dbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64da531621d1a67d3a2e6b2dd51c1ccf0f87a38726341decbdff5c60cd0b1dbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "00675756b0fd3b1bea5c35e0dea68113eaa547257a5ed6e9fcf883ebe0ea452c"
    sha256 cellar: :any_skip_relocation, ventura:        "00675756b0fd3b1bea5c35e0dea68113eaa547257a5ed6e9fcf883ebe0ea452c"
    sha256 cellar: :any_skip_relocation, monterey:       "00675756b0fd3b1bea5c35e0dea68113eaa547257a5ed6e9fcf883ebe0ea452c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac8a84f5bee71e922729d74689693441587bdccfbe045d5a00860d531eec565"
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