require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.2.2.tgz"
  sha256 "342809344a704e98d12eeaba94e9e64631b83963abb0825c07dcfe4b9a791944"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82bbb1035e0c79b0b7a77450c3852ebe18686f434937b9633c69d51ee53c92f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82bbb1035e0c79b0b7a77450c3852ebe18686f434937b9633c69d51ee53c92f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82bbb1035e0c79b0b7a77450c3852ebe18686f434937b9633c69d51ee53c92f8"
    sha256 cellar: :any_skip_relocation, ventura:        "f6973b349159a5b182236e671994c1341397cfabc3cb5eea7531435bc3c7e25b"
    sha256 cellar: :any_skip_relocation, monterey:       "f6973b349159a5b182236e671994c1341397cfabc3cb5eea7531435bc3c7e25b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6973b349159a5b182236e671994c1341397cfabc3cb5eea7531435bc3c7e25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d8609e8810a095b45e62eb72241f008a290f35999c0a3eabcc0dfc10e732f3"
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