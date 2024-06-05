require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.5.tgz"
  sha256 "4fbde9fffb3b3dfdd524802d508e7eab9b83c4efe69fa589f47812ef0b19cf82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b7052e31daa8b4cf6edfedc9277592bdd7bcddd3ba2194fd1fd6cd7c4fa64b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b7052e31daa8b4cf6edfedc9277592bdd7bcddd3ba2194fd1fd6cd7c4fa64b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b7052e31daa8b4cf6edfedc9277592bdd7bcddd3ba2194fd1fd6cd7c4fa64b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b26764b69aa84c796e1bdb029fb664b1d620d5652842754a018eb23bdafe5b90"
    sha256 cellar: :any_skip_relocation, ventura:        "b26764b69aa84c796e1bdb029fb664b1d620d5652842754a018eb23bdafe5b90"
    sha256 cellar: :any_skip_relocation, monterey:       "b26764b69aa84c796e1bdb029fb664b1d620d5652842754a018eb23bdafe5b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c09e1a62ae69e1a92362f63745ea336e9872105a2498aba2f4909eb033ba777"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end