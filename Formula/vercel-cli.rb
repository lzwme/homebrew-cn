require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.18.2.tgz"
  sha256 "effad202714cf0dbf45daae941bf88ef708e0d5abf95f48cf5968b0c14a477af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a352f6cbe1bc7490a911311adc7a4ad5d7846162213678234b2af0393d80e79e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e8b6999bd2ba068848af0ad8baa5744abce22c24f7a34c215eb69fa70b1e3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56b30f8b0481b6582e64c62eb64feb77084b4b8de7a41280078a3b9871d370bd"
    sha256 cellar: :any_skip_relocation, ventura:        "e97f4bf5c21da28d32997848330ca725f23a6794e2179e9027af816874d131b5"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b2040bf8bd70585965ea9222a1cd719535295f6c6165a66101437592f4c5a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a970cbede92058fbd224bc68d762230d3d5bf43658d5d37e7d925159f4ac720f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eb227105e08d71dd7d38a36f1056ed573d7a299e64b17b4e5723b8bc8aa1934"
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