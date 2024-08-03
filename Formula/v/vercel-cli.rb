class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.2.3.tgz"
  sha256 "33bcee967fcac6e57e705e58732170c1a5dda90df9f971ba7c068c3ceede5568"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1036db610ae357b4f47b86a5553174fad1b35019bcae5349fbb84c61d133689b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1036db610ae357b4f47b86a5553174fad1b35019bcae5349fbb84c61d133689b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1036db610ae357b4f47b86a5553174fad1b35019bcae5349fbb84c61d133689b"
    sha256 cellar: :any_skip_relocation, sonoma:         "780c2f440341c3e89fa4de4bdc729d662c68203c4ba652282617ef4dfe5a042f"
    sha256 cellar: :any_skip_relocation, ventura:        "780c2f440341c3e89fa4de4bdc729d662c68203c4ba652282617ef4dfe5a042f"
    sha256 cellar: :any_skip_relocation, monterey:       "780c2f440341c3e89fa4de4bdc729d662c68203c4ba652282617ef4dfe5a042f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a485be1b7bd57c2c603fa3efd681dc3044796f1d8fdceb1f7c98730dd3c7c6df"
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