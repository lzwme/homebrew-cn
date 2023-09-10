require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.2.0.tgz"
  sha256 "ddbe14452627c16997b6c62c9cfb76ef6fadf668ec228779082acbf06c0e185a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b22eb25806f63adc9d6592bb26d81f5c2f7a776011335b88d8b2aa01ea8d825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b22eb25806f63adc9d6592bb26d81f5c2f7a776011335b88d8b2aa01ea8d825"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b22eb25806f63adc9d6592bb26d81f5c2f7a776011335b88d8b2aa01ea8d825"
    sha256 cellar: :any_skip_relocation, ventura:        "490db61f5a14fc4784565060681d7e1c55e650e3902c0d2aed05d835415ac7c3"
    sha256 cellar: :any_skip_relocation, monterey:       "490db61f5a14fc4784565060681d7e1c55e650e3902c0d2aed05d835415ac7c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "490db61f5a14fc4784565060681d7e1c55e650e3902c0d2aed05d835415ac7c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79bf5e842ef518e7a5f07a354924ace7fce730408d27a23de3809a38e8d0c425"
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