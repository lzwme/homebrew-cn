require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.2.3.tgz"
  sha256 "ab391605cfd354c60fb0048266429e87bacf0408aa147618ab4259b89e33c64a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27b005a486df40f14cbb8507d1592f0476ee8bff36baed2df9f51e41b02181a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27b005a486df40f14cbb8507d1592f0476ee8bff36baed2df9f51e41b02181a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27b005a486df40f14cbb8507d1592f0476ee8bff36baed2df9f51e41b02181a4"
    sha256 cellar: :any_skip_relocation, ventura:        "c5a4453cf644a107f7f134d5a5bb9bf21cb316da87532185df26a76f72a27ab8"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a4453cf644a107f7f134d5a5bb9bf21cb316da87532185df26a76f72a27ab8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5a4453cf644a107f7f134d5a5bb9bf21cb316da87532185df26a76f72a27ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13e097df2fd19678b3e9fce78f34d9ad0cf0e1e62272670da6bea4b10968f951"
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