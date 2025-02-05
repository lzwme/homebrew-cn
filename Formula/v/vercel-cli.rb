class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.0.0.tgz"
  sha256 "748b455f656d591ef14b4b3af71c5432c3b6680f94a794b0ea999e280a43f6c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec4d5a666c648b9be8dc3e0df6c7908d2321596c2c9e5fdab37e1ff19b757c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec4d5a666c648b9be8dc3e0df6c7908d2321596c2c9e5fdab37e1ff19b757c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aec4d5a666c648b9be8dc3e0df6c7908d2321596c2c9e5fdab37e1ff19b757c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c24b93b976ebed9087e9d1a3de29454c073dd258e1950c55dbe67831f269180"
    sha256 cellar: :any_skip_relocation, ventura:       "0c24b93b976ebed9087e9d1a3de29454c073dd258e1950c55dbe67831f269180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745da604e9c22a1db256571b1d0622c67df6e1029f91a048a039d8b7f006f8c7"
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