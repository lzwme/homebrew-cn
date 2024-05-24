require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.2.tgz"
  sha256 "18915a44de67ff411e1c3269a5c535a23cf3c0b07054e16a664e3d90acefcd8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71f7addf12bf01428248c56d1c64f43ca2770a43ee1a0954167f1f5741d5b092"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32bde650e8e8eb4c3390300ff4cd3a05f85dc41b54aa12418cee7a6686f3b164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ab141a66418a29393be44b0b3d68611cd8f89daee910f65575c097d7cf232b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dd7c916cffd4b53187642bd4c961d828cf661b1ae74f881a26b9fa75088f86a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d5f889553df3148fce905cf93336a292f8dcab1e8e07040b2b8a5b487db3463"
    sha256 cellar: :any_skip_relocation, monterey:       "15898f0c9ad2a04f7d40cab450390dfd5c710d2e96a8d66c4003e1c6a78c2f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a65064ad474a0ca0860f479cf454db4d1401c6d1d9e9b91ea045d8874260a49"
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
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end