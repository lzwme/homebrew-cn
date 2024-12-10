class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.2.0.tgz"
  sha256 "120a89def6ceb63418b47e9b81c4dc1622b46b64037cb0cd228446bdbcce5d71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de49fdba5fb06f0fb91ec7250515f53179387274b0d16dc5229f2d87add69588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de49fdba5fb06f0fb91ec7250515f53179387274b0d16dc5229f2d87add69588"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de49fdba5fb06f0fb91ec7250515f53179387274b0d16dc5229f2d87add69588"
    sha256 cellar: :any_skip_relocation, sonoma:        "f30afe7a719523c260c141e02b83d9960ff67e364eb1757ff3740a973f2fd81d"
    sha256 cellar: :any_skip_relocation, ventura:       "f30afe7a719523c260c141e02b83d9960ff67e364eb1757ff3740a973f2fd81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "149036e938503c7211c18be3df8ab3fa5d99f47f8c768afdfe74f5eaa9757e57"
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