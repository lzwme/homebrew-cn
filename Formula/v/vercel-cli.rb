class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.31.0.tgz"
  sha256 "fe9dbac4415b75c6cea6e293e80a6a536fb85a467e321cb0db208038356633cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fa0e525008ca5f385d7b9bd03e7c988a9ff71c4f4df0a5067feccad8bcbfc95"
    sha256 cellar: :any,                 arm64_sequoia: "733b3af1f4074df56becadc4792ffc3ca24f0de581011328001740ea765af210"
    sha256 cellar: :any,                 arm64_sonoma:  "733b3af1f4074df56becadc4792ffc3ca24f0de581011328001740ea765af210"
    sha256 cellar: :any,                 sonoma:        "8b0323cf6e9aa862711ba570d80876f42f35a78b0d1dbfca75a4767dc0f4f5d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f11003e2e0a89b9aede35ad56b8c6e155270989ddf18322b6bdaba09a0d3f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf5d4e97381273a1f405084a3ae63b254d09110a24b6d40bc1b927ce5f24b26"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end