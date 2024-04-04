require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.6.3.tgz"
  sha256 "50f72fdbf27e210e48c3304e0dcb3c50d59bf817c69d58258fec353107bab01e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "512f12f62aa48bb46c7ba5cfcc7da4268e2fc9fa2d340fc8dd034363c9fd5f34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512f12f62aa48bb46c7ba5cfcc7da4268e2fc9fa2d340fc8dd034363c9fd5f34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512f12f62aa48bb46c7ba5cfcc7da4268e2fc9fa2d340fc8dd034363c9fd5f34"
    sha256 cellar: :any_skip_relocation, sonoma:         "83b0030258fd0ddcbf1ace679b8861d5c528b5c22fae066ee2aa4227d43530cf"
    sha256 cellar: :any_skip_relocation, ventura:        "83b0030258fd0ddcbf1ace679b8861d5c528b5c22fae066ee2aa4227d43530cf"
    sha256 cellar: :any_skip_relocation, monterey:       "83b0030258fd0ddcbf1ace679b8861d5c528b5c22fae066ee2aa4227d43530cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467e9183e541e09cb4aface73ed47cb3b87700164991f9540ee4f3bb61730cc0"
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