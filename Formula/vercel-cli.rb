require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.4.0.tgz"
  sha256 "8dfa44a2b6aea6050afed4d7766b7ee5e63cc8bde94586c0b9c44983348c229e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b146197219cea56037ce276a7e65b60b2d41232100f2cbc868a8325a75ccc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bed5983e2fd2ee5a0b37d44acc0e46f9d74972c6bdc93e8ecf32f50d0bad102"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83e013e20e419b790c06c6193561a8e3b8c3b9d5d95cf67ffc58af1c0433d2ae"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1638faf7027d7780fdf1b6cc436d2ace1839af559b3b71c8bfac2f8cd9bcff"
    sha256 cellar: :any_skip_relocation, monterey:       "a44e578de5b2072050130def29e39c6bcdb917fffc9760d8762608b76c04b8c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4861aa7ad49ea9d699449ddfb5fc0c3a06e03d6ffe1edf8c04f4f487b0c62d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c6cebb6bfbdbf63384d7ec8022966f45267d6badca2dc1e9baeaca1b5c1556"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end