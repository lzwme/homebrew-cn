class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.0.4.tgz"
  sha256 "3966934c411d605efd54d7ce3f0a8c233ebf6331cb79ea7b93a3970fb2eabf32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c482c906a8b3b0e5711b7aae80105d89924d5ebef487a90327cd22be9dc2990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c482c906a8b3b0e5711b7aae80105d89924d5ebef487a90327cd22be9dc2990"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c482c906a8b3b0e5711b7aae80105d89924d5ebef487a90327cd22be9dc2990"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b9b4eae260c1364d097e386e3138c53c03f9f4706b8bd0a276645db4dfa027"
    sha256 cellar: :any_skip_relocation, ventura:       "08b9b4eae260c1364d097e386e3138c53c03f9f4706b8bd0a276645db4dfa027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b08c67ef263636ffd0ce6707dece4f2a8edc75ca102e42cbfac5eeb1061ca0c"
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