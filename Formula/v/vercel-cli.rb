class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.4.2.tgz"
  sha256 "07e1086cd6b9ba9ce865240af891c1e4a1a61e759d0c8d2497b80facb7ac1e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ff826a7d9b439efdde63cab2fbbfd87a52f9452fdbeef21a79dd62bab3bee871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff826a7d9b439efdde63cab2fbbfd87a52f9452fdbeef21a79dd62bab3bee871"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff826a7d9b439efdde63cab2fbbfd87a52f9452fdbeef21a79dd62bab3bee871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff826a7d9b439efdde63cab2fbbfd87a52f9452fdbeef21a79dd62bab3bee871"
    sha256 cellar: :any_skip_relocation, sonoma:         "93ea9d98082684c7edf9485f9f0a4e29a51ff08c7aa6d05c6ac4728d9a2c6ae2"
    sha256 cellar: :any_skip_relocation, ventura:        "93ea9d98082684c7edf9485f9f0a4e29a51ff08c7aa6d05c6ac4728d9a2c6ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "93ea9d98082684c7edf9485f9f0a4e29a51ff08c7aa6d05c6ac4728d9a2c6ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4826d5a2d50c9f8329f3ce01686d5cabc667ce25c878d9305e8b5528239965be"
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