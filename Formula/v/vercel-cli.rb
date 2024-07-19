require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.1.0.tgz"
  sha256 "1bb2662301f58ee250248549af0b220651aa327c0c966f76375d4add39e5b182"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2981ce965a42cedad70c0e31a4c8392c6129626cb4a0161778cee7137fbfa52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2981ce965a42cedad70c0e31a4c8392c6129626cb4a0161778cee7137fbfa52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2981ce965a42cedad70c0e31a4c8392c6129626cb4a0161778cee7137fbfa52"
    sha256 cellar: :any_skip_relocation, sonoma:         "b13cc62b08b8125c865ca2967b598cdbff1412ee9f8331418d9ea47e4f802e57"
    sha256 cellar: :any_skip_relocation, ventura:        "b13cc62b08b8125c865ca2967b598cdbff1412ee9f8331418d9ea47e4f802e57"
    sha256 cellar: :any_skip_relocation, monterey:       "b13cc62b08b8125c865ca2967b598cdbff1412ee9f8331418d9ea47e4f802e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4424aebcb47972af071b6492dcbaa36d86d8c5a24c4205fba0cf4e204a536605"
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