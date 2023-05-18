require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.3.3.tgz"
  sha256 "4cf312d86c3b6ec0aae5cc83f9d326e8243c850a2634ae4399f3ff65777d7396"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a533689aef009e411261a9920071d26906e0e9faaf41074d7d67866a510703c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e6ae1dba1814579b0738d794d71183a71fd222d392376e93ee9bea65d55192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07df838e3b39b552fa8926933d1f01f13a5e1d1d482a29a8b8c4939a09fda93a"
    sha256 cellar: :any_skip_relocation, ventura:        "832aacf900515d6eed778fff8293c7f88bad8e741d53ab6c1dbf3837517773c2"
    sha256 cellar: :any_skip_relocation, monterey:       "be7c50bb9dd36e5b29c93119f67aeeb08bc582b0de9ee16965246c541e2caeae"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cf8e36f573f77cc2ceb1088f7a697cdb24c83baecc50bb2548cbef88c4f8dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b21160a046b48ac242215622ddd00b9823d484f683fbc199ac0861b3b3ade34"
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