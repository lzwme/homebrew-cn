require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.2.2.tgz"
  sha256 "af489b595daeac99f04baab1bfe24dca9d4c103391ac9d6ab9671ac77f0135a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a768f00758f1120cb79fc6741f589da3c064a54fcb3352ad12c686bd022b4699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a768f00758f1120cb79fc6741f589da3c064a54fcb3352ad12c686bd022b4699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a768f00758f1120cb79fc6741f589da3c064a54fcb3352ad12c686bd022b4699"
    sha256 cellar: :any_skip_relocation, sonoma:         "44196b37a0b08432a49ca09c322556576c27207b6511abd47d65696038ea077c"
    sha256 cellar: :any_skip_relocation, ventura:        "44196b37a0b08432a49ca09c322556576c27207b6511abd47d65696038ea077c"
    sha256 cellar: :any_skip_relocation, monterey:       "44196b37a0b08432a49ca09c322556576c27207b6511abd47d65696038ea077c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e5d46519052533fe50b38e133f63e1393c5ee33d5512b4cabe4db36e871ab2"
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
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end