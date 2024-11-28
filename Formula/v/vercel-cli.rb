class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.1.2.tgz"
  sha256 "bc829667f63450b7c2f2d46a7a6e38475c7665d1739e8b55562d098daf8bae39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a657a533fffa7e58aa231c7dc5db243f690cfbe31f7139c44a09ad9589511f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a657a533fffa7e58aa231c7dc5db243f690cfbe31f7139c44a09ad9589511f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a657a533fffa7e58aa231c7dc5db243f690cfbe31f7139c44a09ad9589511f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "da3fae070d189cd6b67216c62795151fb996776426383f937bfb176e2f361953"
    sha256 cellar: :any_skip_relocation, ventura:       "da3fae070d189cd6b67216c62795151fb996776426383f937bfb176e2f361953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a990dcb7a23aa53f178697934ef222d28037ad11d7c11fd5c756685291c156"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end