require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.0.1.tgz"
  sha256 "174d408d9319c2e1d75ac1e6957d61cfcb0206bdcc272932e3c9ec475fdd8284"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e31b803b843f9db8d5d34fa34ff0beb43f463d5b02331fc9c02623c0c8740fb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e31b803b843f9db8d5d34fa34ff0beb43f463d5b02331fc9c02623c0c8740fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e31b803b843f9db8d5d34fa34ff0beb43f463d5b02331fc9c02623c0c8740fb7"
    sha256 cellar: :any_skip_relocation, ventura:        "23c32444ec0b1e304b422a8c64a4c95666349d9243abdf565efc0298364b5be6"
    sha256 cellar: :any_skip_relocation, monterey:       "23c32444ec0b1e304b422a8c64a4c95666349d9243abdf565efc0298364b5be6"
    sha256 cellar: :any_skip_relocation, big_sur:        "23c32444ec0b1e304b422a8c64a4c95666349d9243abdf565efc0298364b5be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48de6413e8fff9ad04be9e73af295177f253b3d1fe9fea050c8b5640d35fed95"
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