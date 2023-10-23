require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.5.0.tgz"
  sha256 "39137f0ddabe9ca9fcafdb84620f9ff0b42297cef11c01f2aad86113be08288b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c0b623a61e31992e37ab67d9c0403de981e577cc146152facc884676377d0e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c0b623a61e31992e37ab67d9c0403de981e577cc146152facc884676377d0e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c0b623a61e31992e37ab67d9c0403de981e577cc146152facc884676377d0e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fa899cee054a71e9c2e5fcd5a1ea94af0c2a13587555593c8cb94c4b88231a2"
    sha256 cellar: :any_skip_relocation, ventura:        "1fa899cee054a71e9c2e5fcd5a1ea94af0c2a13587555593c8cb94c4b88231a2"
    sha256 cellar: :any_skip_relocation, monterey:       "1fa899cee054a71e9c2e5fcd5a1ea94af0c2a13587555593c8cb94c4b88231a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcbab68e6eb73a0050e3aecf78d66d47d513a7dcabae21a6df5806e48a339104"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end