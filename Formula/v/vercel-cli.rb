require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.2.4.tgz"
  sha256 "b1389f20611044bad073c55af388353feabdf115865fed8d50abbbfacf8c8256"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d5e00003ef85b5ec7972ee1632892bd7474df689c1f79e0c1489b6c3f4950f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d5e00003ef85b5ec7972ee1632892bd7474df689c1f79e0c1489b6c3f4950f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d5e00003ef85b5ec7972ee1632892bd7474df689c1f79e0c1489b6c3f4950f8"
    sha256 cellar: :any_skip_relocation, ventura:        "5366b705a05f49e8acfd197a7fdac369a4fbe554d9bde093497aa1c0dce9c17e"
    sha256 cellar: :any_skip_relocation, monterey:       "383a174bd7a82446601fe34be66b2f47b6b6a65a8ebe674afdbf24e63a985c2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "383a174bd7a82446601fe34be66b2f47b6b6a65a8ebe674afdbf24e63a985c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdebfdf71d999c8173a4731c659e8b9bf1ba81d3a2d01717cdb4e51fb0c979c9"
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