class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.1.2.tgz"
  sha256 "0a2e2b12b60a81d5240dfd96b6aee1345ce890584743f00b1ad4b6d9beea3b71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11b0bc962a87820b7516d9f351bcee9b71837fff25d53370277a8cbc0afffb6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11b0bc962a87820b7516d9f351bcee9b71837fff25d53370277a8cbc0afffb6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11b0bc962a87820b7516d9f351bcee9b71837fff25d53370277a8cbc0afffb6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ccbdff73c8ded96487c6e52288e255f85f4bc8e85b3ef374992bd6ea49e5e51"
    sha256 cellar: :any_skip_relocation, ventura:        "6ccbdff73c8ded96487c6e52288e255f85f4bc8e85b3ef374992bd6ea49e5e51"
    sha256 cellar: :any_skip_relocation, monterey:       "6ccbdff73c8ded96487c6e52288e255f85f4bc8e85b3ef374992bd6ea49e5e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf7b3b1ccad5e3eec266671a4582b54cd8a14c44cd4801496490c8997d09034f"
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