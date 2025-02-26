class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.2.2.tgz"
  sha256 "cb7da8edcdecc37acb1eb1d29331c26ed147c9e4c293e9821c1cc62710de966c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbdb48cd2deb72657ece4de5e826c5563a6aad78a3904fe9ed09bdbd92c6251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bbdb48cd2deb72657ece4de5e826c5563a6aad78a3904fe9ed09bdbd92c6251"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bbdb48cd2deb72657ece4de5e826c5563a6aad78a3904fe9ed09bdbd92c6251"
    sha256 cellar: :any_skip_relocation, sonoma:        "be013575a093abd0811726c84f4a3a2dfa8e4f553a654614739d356bbe764962"
    sha256 cellar: :any_skip_relocation, ventura:       "be013575a093abd0811726c84f4a3a2dfa8e4f553a654614739d356bbe764962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b695b1eb72003bea592e3fd74f16706cac39a9cb8e0692133f033498cb96a06f"
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
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end