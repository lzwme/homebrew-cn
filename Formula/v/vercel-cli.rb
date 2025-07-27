class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.6.3.tgz"
  sha256 "15ac672f463be27dbdadbe2ccc41de87bf2dbbc1117fc9580d95223a87078da3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f879784029c6a713c141fe8436d76f2a354b57cac40b5013b22befe4e4d0f21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f879784029c6a713c141fe8436d76f2a354b57cac40b5013b22befe4e4d0f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f879784029c6a713c141fe8436d76f2a354b57cac40b5013b22befe4e4d0f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9b1ecab40f8281b0cbeb2bdc387802c56dbd63ea78aa4fdcac677874efaf79"
    sha256 cellar: :any_skip_relocation, ventura:       "be9b1ecab40f8281b0cbeb2bdc387802c56dbd63ea78aa4fdcac677874efaf79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5991e484e9a07a501e27067e694e58e52506868e047984cc0bbd311fad18e0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d0252b919f8e51f6ecebe5e5071be268582c66f2c37eecbda03ec8d81e2a8c7"
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