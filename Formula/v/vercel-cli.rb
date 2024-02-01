require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.4.1.tgz"
  sha256 "4f7ec2fced3f81321656ccf085091753a35f855722e04cd214b5a0bb1ce8a9d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b789b0e8c1d632aa61c51ca2f0b446eee08d3abcb41c401968ff4ed66190fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69b789b0e8c1d632aa61c51ca2f0b446eee08d3abcb41c401968ff4ed66190fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b789b0e8c1d632aa61c51ca2f0b446eee08d3abcb41c401968ff4ed66190fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "79ae4a4b8fd4a90a8a3c281ae4b8879191b248da42d1f5cf655c97c6e06b92cd"
    sha256 cellar: :any_skip_relocation, ventura:        "79ae4a4b8fd4a90a8a3c281ae4b8879191b248da42d1f5cf655c97c6e06b92cd"
    sha256 cellar: :any_skip_relocation, monterey:       "79ae4a4b8fd4a90a8a3c281ae4b8879191b248da42d1f5cf655c97c6e06b92cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3213b5f2e67b783e28f5b80f90151633d9d9e75e78585e2bee8297cff12f453e"
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