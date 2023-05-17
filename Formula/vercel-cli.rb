require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.3.2.tgz"
  sha256 "6c8b2edad3d055a1306fda3d8b57b755004eec04c03a99e1ae573f8a6151ba98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49facd2f6900ae4f0db0bcf5e0fa1b4da27820ceea9739f0b13a24c7804bc261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277cb1f7ecfc5fd9c3548d190997bb08e57ae6de351a342ec02197c854f0dfad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "252bb6a782905ef36eb8375366b82c6426762247c932ec1cba0f8318383f07ba"
    sha256 cellar: :any_skip_relocation, ventura:        "096e87944821560d6874833496f5098322038ea8e133cbf529f495bd845d7229"
    sha256 cellar: :any_skip_relocation, monterey:       "f15e70494e4ba95f5e5a5f1311a9478e90a9fddb4702a1bee272e89df67d28b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8559ff4815746c2aa16055230589753fff8439b7f7a0d61ec19c4eeed25106b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb6ce0bd0ec19b0ff9d0e740ae37724bff2baf76f78b6ac68467b62183bc9f3"
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