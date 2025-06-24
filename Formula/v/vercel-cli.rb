class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.1.0.tgz"
  sha256 "33ef2c46bee8bd96bc12f0aa6019533ec6fba864b6bdbae309d23f2c9fa779fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c1a0ccb2a8dfeb1b2b98f684c6c6a4c63fc78fbc90d3fdfb934c0ee60a9f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92c1a0ccb2a8dfeb1b2b98f684c6c6a4c63fc78fbc90d3fdfb934c0ee60a9f8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92c1a0ccb2a8dfeb1b2b98f684c6c6a4c63fc78fbc90d3fdfb934c0ee60a9f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab2c359e0172d88fe64860058e9b02b0623bbdb1e69928354a6abe26d2b59526"
    sha256 cellar: :any_skip_relocation, ventura:       "ab2c359e0172d88fe64860058e9b02b0623bbdb1e69928354a6abe26d2b59526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14bfe80700143c54e223f3b07da4d05eaff2d67f5e909080edf4cc5f1b5f2a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0ca5ed203ea1db6301a8763b73098580dee8033ad90cf9beacd3803aaeac0e"
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