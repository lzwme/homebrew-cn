require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.5.0.tgz"
  sha256 "37e79d088fd004181bd6a3401de07c2de4c2a022ede3d36c87de3b2a9d21d03a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50191554f0b907234ded730be623b8e6b5f9ae339c2a1fecadb3f895dafbe696"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50191554f0b907234ded730be623b8e6b5f9ae339c2a1fecadb3f895dafbe696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50191554f0b907234ded730be623b8e6b5f9ae339c2a1fecadb3f895dafbe696"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d8cfef30cc7159e037c587e9d72e0d0a959f2836897c90f5079e9efcfb8e964"
    sha256 cellar: :any_skip_relocation, ventura:        "2d8cfef30cc7159e037c587e9d72e0d0a959f2836897c90f5079e9efcfb8e964"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8cfef30cc7159e037c587e9d72e0d0a959f2836897c90f5079e9efcfb8e964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b94e6673f43bbbfc3a28ef804a0cbb5a25f439ce896ccff7a009ec5dbbfb6b"
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