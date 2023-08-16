require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.3.1.tgz"
  sha256 "e44dc60317c9ec83849d5a8efee8208a5acfeb3bb42b11b73fbc0fb6bf860455"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdac3b47b32b9616b5c4f9f729d5b018a07c17206a14ca720c38d78d1a7b440f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdac3b47b32b9616b5c4f9f729d5b018a07c17206a14ca720c38d78d1a7b440f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdac3b47b32b9616b5c4f9f729d5b018a07c17206a14ca720c38d78d1a7b440f"
    sha256 cellar: :any_skip_relocation, ventura:        "e69a15538bf4dd52221e7e866e980eaa79c1fac1cf3c5c20f677ef3ded58487d"
    sha256 cellar: :any_skip_relocation, monterey:       "e69a15538bf4dd52221e7e866e980eaa79c1fac1cf3c5c20f677ef3ded58487d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e69a15538bf4dd52221e7e866e980eaa79c1fac1cf3c5c20f677ef3ded58487d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100185e5b0508e8010358bc29f08f2b3ec0d38db2f6ea26ea6f3c90336feb1e5"
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