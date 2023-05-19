require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.3.4.tgz"
  sha256 "30c035bccd0e81c20fe641ba1b3e02f05b4181cdff0dae8ba9a0e4e5d59d1764"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ca74315eab9e70457f845ec3baab781cfbbbdbd88ce0ca9623da59a337536e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae211136a0018a24906460ed223346c7672101c81e84c97c739e638a3706fb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4927caaa1be6ae39ce5eebe2ae7b9705508571f3dd71f123ccfd13e060eaa064"
    sha256 cellar: :any_skip_relocation, ventura:        "aa63631b20106d64819ff2aca13daa9a9ee3409604744f02a89ea85a220ad9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "53f10f57945856d2f07e76c02676d0fe5ff1f2839b60a295e77bd6d342b0df67"
    sha256 cellar: :any_skip_relocation, big_sur:        "2229120ebf6a1a003125be26fcb22e2d86145d1549071086e6402ebc7544415e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b61689713c1c940396d510dc844871c23868181c1dcb7f6d43db18e687d2128"
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