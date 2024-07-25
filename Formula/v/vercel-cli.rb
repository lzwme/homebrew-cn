require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.2.0.tgz"
  sha256 "2f9cedbca67f39b2fe45a4b753b6638cda078925c62e7eac0a13e68dd57ac619"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e207bd7ef2541817e739f8157210b10f94b5c853c095bb78799613be2f3328a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e207bd7ef2541817e739f8157210b10f94b5c853c095bb78799613be2f3328a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e207bd7ef2541817e739f8157210b10f94b5c853c095bb78799613be2f3328a"
    sha256 cellar: :any_skip_relocation, sonoma:         "41e6dc1548170567938a847d2f221d490830d235be01dab381b11d13cdbf1a3b"
    sha256 cellar: :any_skip_relocation, ventura:        "41e6dc1548170567938a847d2f221d490830d235be01dab381b11d13cdbf1a3b"
    sha256 cellar: :any_skip_relocation, monterey:       "44e0a46d6b1e1d80e2f3a09b1544c3211c9dfaa4a4e7d1d95845f6d5ed45cbd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0df14a85cee478f13d7a1613b85ec0ea8fd4125f922e5e13d94e20fc8857cbe"
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