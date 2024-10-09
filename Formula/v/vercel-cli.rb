class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.6.3.tgz"
  sha256 "af94cfc6bbf894b47e17fa5bf25c75265991ef9d607a30e2060f310f65f73285"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe404aa6a8feaa17fc93fa3af4d8ef0414e8c6b9f67856a7a9dc17ea8e2e3633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe404aa6a8feaa17fc93fa3af4d8ef0414e8c6b9f67856a7a9dc17ea8e2e3633"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe404aa6a8feaa17fc93fa3af4d8ef0414e8c6b9f67856a7a9dc17ea8e2e3633"
    sha256 cellar: :any_skip_relocation, sonoma:        "18b510779eebe94b6ce77d53212c6912503ac124843f52213b1ce393cd542e27"
    sha256 cellar: :any_skip_relocation, ventura:       "18b510779eebe94b6ce77d53212c6912503ac124843f52213b1ce393cd542e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b699bce340441758ec69c93b4073b90cef093fd5dadcdc2439f474e68257218d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end