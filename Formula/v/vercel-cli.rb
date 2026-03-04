class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.26.0.tgz"
  sha256 "94eaeb2b95d9bdb71043205ccc97a9bc1e693949b8056e49be3c89b20fddcbc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac8b8f34ed1e3878a36389d65b721f4505da2f34a49e85a8a412f67f37b3ea8d"
    sha256 cellar: :any,                 arm64_sequoia: "439c63deed662a4aecbd42660dffc49646d9957d3fec82dcd786df31b2aa3818"
    sha256 cellar: :any,                 arm64_sonoma:  "439c63deed662a4aecbd42660dffc49646d9957d3fec82dcd786df31b2aa3818"
    sha256 cellar: :any,                 sonoma:        "0a98544a008195f38e01998ae4935dba130d7216ad5a3b93508682f036062f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f921ff25220661fbce9596085e4c8931238b3e6ebac59ab3731756ca0486372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5892085e2a1855470ffae1b57f57edbc6fb64163eeef2ab72ee623f443f5920"
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