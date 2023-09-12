require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.2.1.tgz"
  sha256 "06130bb109db07a6bc4c221b140fb9ebd21d5eeadbc60acc097d0819369b3194"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd609002965f55e16353ab3e0c99131d746e5882ecdc31c406a27cf9fb934e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd609002965f55e16353ab3e0c99131d746e5882ecdc31c406a27cf9fb934e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd609002965f55e16353ab3e0c99131d746e5882ecdc31c406a27cf9fb934e1d"
    sha256 cellar: :any_skip_relocation, ventura:        "35a7412f3db66fa92003c210da27ff1518d467d115a3bff8f8e7dd3ccf523eda"
    sha256 cellar: :any_skip_relocation, monterey:       "35a7412f3db66fa92003c210da27ff1518d467d115a3bff8f8e7dd3ccf523eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "35a7412f3db66fa92003c210da27ff1518d467d115a3bff8f8e7dd3ccf523eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd99cb90bbf778a9f6f61d692d25989922d2369702ae734d9b56bebaeda12351"
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