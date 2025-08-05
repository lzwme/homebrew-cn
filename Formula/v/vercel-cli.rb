class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.7.2.tgz"
  sha256 "7917070cb5e66641034373b4b80f0506d2670c19d134628045c16dddc74c9d6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737262f0af4ae3d65e27c9b6aec94a7798aea7167d0eea182ed32219ad9bac2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "737262f0af4ae3d65e27c9b6aec94a7798aea7167d0eea182ed32219ad9bac2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "737262f0af4ae3d65e27c9b6aec94a7798aea7167d0eea182ed32219ad9bac2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d7dde51b602a37a60f0a27a53d41b672ea66d7ba2526b11e55de47ce27d1772"
    sha256 cellar: :any_skip_relocation, ventura:       "0d7dde51b602a37a60f0a27a53d41b672ea66d7ba2526b11e55de47ce27d1772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7043cedf586e7ced6ddb74c508aa3e7edacaced03e60ee0824b3cd3978a7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "239f3d01a7bbbd1781a9b5c2b7dbea1148f451d4a01984270dc198c0f06b2b2e"
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