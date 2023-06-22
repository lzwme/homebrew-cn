require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.2.3.tgz"
  sha256 "53f982bc5c789203cb746c158343eeeaa17789bdeb1c364540a561d19601a1f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce14f46835eb37d524a63054720d1a12e064e60d853fcb8cabd54f4e5e17c42e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f9d5770b5def669486046e920db8078f1bca1aaffc7206032b8654f05c8d2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf738f9c1d97e5b66f7ace722f378fde8b07b1cae26a6d4e962508fe35644fa"
    sha256 cellar: :any_skip_relocation, ventura:        "ff8ee2688a0f4b05649089701f894630800fe9b5e78d69f4d5b8a8ca0f144dc2"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5733c49f7923543344a1f8a99ebf31ed00d37fbd495cc37d0489ce14dd050e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9d1064c376bbc6a236123aa0a65938f6482e5238e54a7b8fcd86902f8803360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6eff778d2bd696d4d3821b72a1eef91f1b6d794d9788dac3cb083c04bfaec0"
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