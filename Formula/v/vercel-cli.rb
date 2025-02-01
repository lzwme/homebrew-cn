class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-40.1.0.tgz"
  sha256 "1b1210904f006a6c6117dfb804abc4edbcc2f352e91f383afb4456bf1b49f332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9e61a8ddd7ade9bd8c82b79dee0de144130d7b1fb89ee9d6798d883e4b6e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9e61a8ddd7ade9bd8c82b79dee0de144130d7b1fb89ee9d6798d883e4b6e78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a9e61a8ddd7ade9bd8c82b79dee0de144130d7b1fb89ee9d6798d883e4b6e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f24fad812e0fd8255315e564322c9a6fa51c9ff4b8f6c385509f006d9d2aea0"
    sha256 cellar: :any_skip_relocation, ventura:       "4f24fad812e0fd8255315e564322c9a6fa51c9ff4b8f6c385509f006d9d2aea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0e233d255ea10672d031f2b7148e6f1969f5ebe7f5abf5777b7753c3db8783"
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