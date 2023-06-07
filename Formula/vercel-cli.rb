require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.2.0.tgz"
  sha256 "3a077a4e75ae964b8173f050741e7ba191dae0373ac3148beba4b9781c055db4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "192c97589c2e3443228533b0a4dcd1ec50152a09af070d7ebd8f354cb964d689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79a825de589dafe57f3a74642dfbaf8fa3cefd05c343f0e07bceec7dc8d614a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1a6a367ed1d7381cbc541686e260a70e566bef5e946547e72876b24b31c46cc"
    sha256 cellar: :any_skip_relocation, ventura:        "1414c686b7516ecf76287fc2c418770fcc721b013542ad6efabbc97061f0ae27"
    sha256 cellar: :any_skip_relocation, monterey:       "5595ae6c8758aae8b5a0ebeda805f6655380017a382fc24cd9097d380b45dde5"
    sha256 cellar: :any_skip_relocation, big_sur:        "591ca56d8d74540a8ac6b1077614b0308c0cb1eca5eb8af4dc500e217e31090f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b1e491b63bac641b157282d5d0c3b2ffa0924b85b240a4fa626a646ebbf3ed"
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