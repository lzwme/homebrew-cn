require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.6.0.tgz"
  sha256 "9498937a1299c4cf9834607dfbf73a84a34825c0962f28d1498dfec34e21f289"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c573fa2494d7cdc5a5d4dd195946e9dadaf8e5cf87c566d0bb1a5fbd3a0a332"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c573fa2494d7cdc5a5d4dd195946e9dadaf8e5cf87c566d0bb1a5fbd3a0a332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c573fa2494d7cdc5a5d4dd195946e9dadaf8e5cf87c566d0bb1a5fbd3a0a332"
    sha256 cellar: :any_skip_relocation, sonoma:         "a760b4a4274d57fad2cbaaeda315e0be3b6f8f8a474d6fecd135710d31465744"
    sha256 cellar: :any_skip_relocation, ventura:        "a760b4a4274d57fad2cbaaeda315e0be3b6f8f8a474d6fecd135710d31465744"
    sha256 cellar: :any_skip_relocation, monterey:       "a760b4a4274d57fad2cbaaeda315e0be3b6f8f8a474d6fecd135710d31465744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beab934bcce7016236131477ea03d9a921a185ecbf732024ab4726a139f43dc3"
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