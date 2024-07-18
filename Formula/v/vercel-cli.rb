require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.0.3.tgz"
  sha256 "f79e6d7c2a689ea7b804ee73b125749891f315dabfb822819f5bc5e3a4b901d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef7ccdac62e91951506af8b88c017e5f2f68dbb3d0bfe038fa76347e47b9d5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef7ccdac62e91951506af8b88c017e5f2f68dbb3d0bfe038fa76347e47b9d5e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef7ccdac62e91951506af8b88c017e5f2f68dbb3d0bfe038fa76347e47b9d5e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e6406615fc95e341b695858c5ed7ed0f25c8eebaff711b3e0721f3b1bf51ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "0e6406615fc95e341b695858c5ed7ed0f25c8eebaff711b3e0721f3b1bf51ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "ec34932a364d48a089d2d52ca3752a44c136f278c0e8825b34604a2d7ce6d5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed346210708f0e1eff307c9288aef360420d70e55e42939cf2e2d6b44bc858ad"
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