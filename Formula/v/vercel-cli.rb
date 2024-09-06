class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.4.0.tgz"
  sha256 "6594b1b5ac356e8076f79a2e8d2260a689d7fc7020c6911b541ccb4b394963c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9428431c223496234f14284547d779394bfc776b1de00f77c922cd8c57b38a1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9428431c223496234f14284547d779394bfc776b1de00f77c922cd8c57b38a1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9428431c223496234f14284547d779394bfc776b1de00f77c922cd8c57b38a1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c5d6c1595bb3910314dcfeb673a2bebc04dec8affe6078df2e24b5214752681"
    sha256 cellar: :any_skip_relocation, ventura:        "3c5d6c1595bb3910314dcfeb673a2bebc04dec8affe6078df2e24b5214752681"
    sha256 cellar: :any_skip_relocation, monterey:       "3c5d6c1595bb3910314dcfeb673a2bebc04dec8affe6078df2e24b5214752681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb7f42f47c5d5a88c7441aa1674f209aa255377e1fa49cbd7ab06409acc1c53"
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