require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.18.4.tgz"
  sha256 "7ebef9a351e4435d75737ad78fabd3b8f5f63fb07d1fc8daa3ef46e897e82474"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc05d4b2bf0286a28d484d5a3dc831245eaf5db09977108a129f52b9678c088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "031984f725e20a2d41117a5bf883ad4525c17c01f11dc7ec670124386654d457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e80c1525284791195aaeeef2f0ebe3cb28dc51f703eb840107e2a4b6e849a2a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b726da9b66220736f7c6af94e5f0ed0e0ed37c90d2b71214b27b05521bb2bf50"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef19caecdcad3c47308bec81fd33f005e6e08ada31593fa7bbe4a152c0aea3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0df86c2e9500cf810d5aa643f0332a8f1fed978a5cec0a29f027b43788109d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e150faf6a0330e7319e9cd150aef5ca4f65f12524d38a9f3771bf7957c3c23"
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