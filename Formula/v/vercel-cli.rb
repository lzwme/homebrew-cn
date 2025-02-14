class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.1.2.tgz"
  sha256 "5d61b254ad50037153b937cf5933f75ecb5073c650f01fd80175024291d04647"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45a384c55663da515ee650455a2bcd30eb9e815ac6b60826c4769202c6bcede5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a384c55663da515ee650455a2bcd30eb9e815ac6b60826c4769202c6bcede5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45a384c55663da515ee650455a2bcd30eb9e815ac6b60826c4769202c6bcede5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e63f533a515f93384709d30503eb13d33e01d874d60b5d6d931f7306619b3a"
    sha256 cellar: :any_skip_relocation, ventura:       "b2e63f533a515f93384709d30503eb13d33e01d874d60b5d6d931f7306619b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf63cb1fe6de1e1752ba05956c5765b192678f8f971667af0ede12eddc67fde"
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