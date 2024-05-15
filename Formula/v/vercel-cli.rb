require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.14.tgz"
  sha256 "234a68abb011e24509e632bf7dc5522d5741228beb0b771bbdfae070a0a4a0ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4ebc91a59d387a9b57345f6bd83a948a50075a689fe4df2ec52507971c154b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e54e627699b8d0f82fa4b4180194a15f84947900f7e81305eaeb0aedb8198f46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1c00d0d4bdc2fd2a0914ce247569ddeb67459b20c017dca5499fd91a5403409"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffd19a09bc38e576d829da7d760347d4f93ad56402a584333e4e77516ab670ed"
    sha256 cellar: :any_skip_relocation, ventura:        "87202be408db1b57cf8300da86ee88a82ea2e0bfb8df7bf6ed3d543354d52c86"
    sha256 cellar: :any_skip_relocation, monterey:       "c017ea50221030d4623e8b47159dee366c42209f2877e7556975c9b1c731ca84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1968f40928da6d3c88fd63efb8974c72e90c1c1523cdd5eeaf28b1b6f9f9fc40"
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