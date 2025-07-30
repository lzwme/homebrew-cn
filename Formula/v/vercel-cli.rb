class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.6.4.tgz"
  sha256 "70e4a30ec1c2d382f80f1df50345a5e5d74690cea75f7ad6f35d10231ef9c306"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cda0d0732d370285cb3d29af0a996be190a337f24179ed9eb4674ab3e5c08b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cda0d0732d370285cb3d29af0a996be190a337f24179ed9eb4674ab3e5c08b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cda0d0732d370285cb3d29af0a996be190a337f24179ed9eb4674ab3e5c08b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e3ab40d2ecfb26719c5599353be8b2ad77a2e95adb82aacd0614c94ce2a1c5b"
    sha256 cellar: :any_skip_relocation, ventura:       "1e3ab40d2ecfb26719c5599353be8b2ad77a2e95adb82aacd0614c94ce2a1c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16a73ed94220ed98e7cd345b70f243835b491f14c67027387887ea713318c7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91aba4c471a4a5b0dffc8127b976ae1b0315b1fdd24e87d375b4ca1660a180a"
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