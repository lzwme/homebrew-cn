class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.0.3.tgz"
  sha256 "b1ecbb63276e7af8c5ee70a3d0b62c97bd766d07a7a84075fc2ae0b6e67428ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57365f47581305e898e4402c623a41d0dcc99863e8b43ab72e32ffd2501e45a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57365f47581305e898e4402c623a41d0dcc99863e8b43ab72e32ffd2501e45a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57365f47581305e898e4402c623a41d0dcc99863e8b43ab72e32ffd2501e45a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "19f01194fb01da348e6e70e82c8a7de6857c0eb9f7d11dd3f5dac4d95ae043ad"
    sha256 cellar: :any_skip_relocation, ventura:       "19f01194fb01da348e6e70e82c8a7de6857c0eb9f7d11dd3f5dac4d95ae043ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546bfac2e2b147e080578574da361f6918e0076b87c6c79d890cd50461a3d7d1"
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