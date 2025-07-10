class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.3.0.tgz"
  sha256 "a87e592f7e6f37a2dd120b5aaecea88fcd2fefda3f27452d752c07a0e4111e76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82657e9cdcc325b1ecf8bb4cc459598d9f217db65c3ab5f067128f8cc40839e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e82657e9cdcc325b1ecf8bb4cc459598d9f217db65c3ab5f067128f8cc40839e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e82657e9cdcc325b1ecf8bb4cc459598d9f217db65c3ab5f067128f8cc40839e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5207a154d3a23c52c94697a4aa146b26cccfae7e7a3e1e320be79677ba34702"
    sha256 cellar: :any_skip_relocation, ventura:       "d5207a154d3a23c52c94697a4aa146b26cccfae7e7a3e1e320be79677ba34702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7344761bd5c1918a2d3e62a1ac68989ddf9cd70e84e5fde0a63df72639426dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6123d8be62e34e1dcc4e511bde1669e652af28fa1b6e3ebf05f8aee70268dbcb"
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
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end