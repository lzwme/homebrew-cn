class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.2.4.tgz"
  sha256 "3fcc37a9c22f559631c1e9976d89ecd0e8099c440dcf415d67e88f05cfc81104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb07a3593bac52eb5b01a95bff9ac8e89ec5ee5d8539cb9e068cf62f202111a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb07a3593bac52eb5b01a95bff9ac8e89ec5ee5d8539cb9e068cf62f202111a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb07a3593bac52eb5b01a95bff9ac8e89ec5ee5d8539cb9e068cf62f202111a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c2dfe97c47f774180e6db755884bc80fe88ee3523f7a1593a29b916a9a0c95"
    sha256 cellar: :any_skip_relocation, ventura:       "d7c2dfe97c47f774180e6db755884bc80fe88ee3523f7a1593a29b916a9a0c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4889885546593e9d5fcb7f1895d344263c6994f6f03617a6a330217aed31b00a"
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