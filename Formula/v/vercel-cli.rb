require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.4.tgz"
  sha256 "3e871c8b5629621c84e9f43c1890dd9383b7ffb0f4bae2d4bab9dd811156c3c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2e6145ba96e317ecb14304228f12e772ec5166603676af4e7ca972fd1b022fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e6145ba96e317ecb14304228f12e772ec5166603676af4e7ca972fd1b022fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2e6145ba96e317ecb14304228f12e772ec5166603676af4e7ca972fd1b022fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "52f88868a40c3955ea8266fa5b63e1a5f30d0dc108ca5997ec46a7080ee4db7d"
    sha256 cellar: :any_skip_relocation, ventura:        "52f88868a40c3955ea8266fa5b63e1a5f30d0dc108ca5997ec46a7080ee4db7d"
    sha256 cellar: :any_skip_relocation, monterey:       "52f88868a40c3955ea8266fa5b63e1a5f30d0dc108ca5997ec46a7080ee4db7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb67ba0ca0553719fa0bf8fee9b825ec587530072588522a8805c14299b47df"
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