require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.3.tgz"
  sha256 "4656cac6bd18e5fed40ab7fef6cef639fd13d37b015c11a202378f5aebf4ebb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc7feab236e599a5a54197460a4bb74dc5c3e8034b3ea1490f2701a8805ff78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc7feab236e599a5a54197460a4bb74dc5c3e8034b3ea1490f2701a8805ff78c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc7feab236e599a5a54197460a4bb74dc5c3e8034b3ea1490f2701a8805ff78c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4c75b90cba3ced71997fe01060bc6e971340995834ac8e9617249f3da491cb2"
    sha256 cellar: :any_skip_relocation, ventura:        "e4c75b90cba3ced71997fe01060bc6e971340995834ac8e9617249f3da491cb2"
    sha256 cellar: :any_skip_relocation, monterey:       "e4c75b90cba3ced71997fe01060bc6e971340995834ac8e9617249f3da491cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15406d5d988a21d10ea2076b466dfa63bfa77150fb0fdbcfb42183790974c3f0"
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