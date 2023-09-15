require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.2.3.tgz"
  sha256 "8d03d4efea10bb5f294d650f93dab7f641afa43c4755b3fda6232a5e2be4576c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b573611b13c9480ab7cc79af62a52045052a2b5cd70e8907fc61e326bd2e1a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b573611b13c9480ab7cc79af62a52045052a2b5cd70e8907fc61e326bd2e1a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b573611b13c9480ab7cc79af62a52045052a2b5cd70e8907fc61e326bd2e1a1"
    sha256 cellar: :any_skip_relocation, ventura:        "20d377a55b228108aff33fdacf88fd121e4e0f3ecb01e7e3a4ba7adccd055019"
    sha256 cellar: :any_skip_relocation, monterey:       "20d377a55b228108aff33fdacf88fd121e4e0f3ecb01e7e3a4ba7adccd055019"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d377a55b228108aff33fdacf88fd121e4e0f3ecb01e7e3a4ba7adccd055019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d0628a04d9858a17b0d738a9abc02c2fd3c26492e985fc7767dc3d78b4caef3"
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