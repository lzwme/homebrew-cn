require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.5.5.tgz"
  sha256 "fc5aabff7856b8e9ccc5071593c55ca1be34b3b32d833d4bd5ff9f7bea1d075d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74137e312619abfb5f34679fb74f672a6da769ccc3912ced27ce3b7f63e69111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74137e312619abfb5f34679fb74f672a6da769ccc3912ced27ce3b7f63e69111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74137e312619abfb5f34679fb74f672a6da769ccc3912ced27ce3b7f63e69111"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2c76444d7131fd55468e138fb98a715f6d587b9b235a3c2b40dd7e7df9d899b"
    sha256 cellar: :any_skip_relocation, ventura:        "e2c76444d7131fd55468e138fb98a715f6d587b9b235a3c2b40dd7e7df9d899b"
    sha256 cellar: :any_skip_relocation, monterey:       "e2c76444d7131fd55468e138fb98a715f6d587b9b235a3c2b40dd7e7df9d899b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cc4a437a2530a841dd41dd86ba5ff49d94f69e65b4076ad8dfae21795f6d804"
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

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end