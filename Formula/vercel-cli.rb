require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.3.0.tgz"
  sha256 "35ffe0b654c80bbb72c409b4788471ee6c6b9ecfbe941fc5105fec3d2bd4510f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9024888ca5358396a55a637c024418d238f8cab5779664ee2ef17013665d8f00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9024888ca5358396a55a637c024418d238f8cab5779664ee2ef17013665d8f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9024888ca5358396a55a637c024418d238f8cab5779664ee2ef17013665d8f00"
    sha256 cellar: :any_skip_relocation, ventura:        "b02c76deb57e0133add8460f684ca604ba2129426fd06b9cb98ec98f12c874ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b02c76deb57e0133add8460f684ca604ba2129426fd06b9cb98ec98f12c874ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "b02c76deb57e0133add8460f684ca604ba2129426fd06b9cb98ec98f12c874ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8df2dbf1616cfb7d6d4b32022c593701c5c9f5f6925d0009c562e5e3461756"
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