class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.0.2.tgz"
  sha256 "9ae204bc64d0752ff950eba9ccf36e75feba1465f9708c72d06ef6e6bdd7bdaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2482779164b39008d66551f5ad16e8e82a8c7e5a48e550960a7c17ba6ba73f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2482779164b39008d66551f5ad16e8e82a8c7e5a48e550960a7c17ba6ba73f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2482779164b39008d66551f5ad16e8e82a8c7e5a48e550960a7c17ba6ba73f26"
    sha256 cellar: :any_skip_relocation, sonoma:        "239eccf473345e177ecf8766d11a32d2513cc6a614476efdfaa68e0b19be2b09"
    sha256 cellar: :any_skip_relocation, ventura:       "239eccf473345e177ecf8766d11a32d2513cc6a614476efdfaa68e0b19be2b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6e523d4e04706bf7c67ee466bf0230a40a31eab7be2d1cd999a170fd5b3f85"
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