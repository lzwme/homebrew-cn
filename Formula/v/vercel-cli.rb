class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.2.0.tgz"
  sha256 "a6701a38b9ed63971dc87c9b5b70f101a7f73f98a9ad3996e01d5eb4aa36cca9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e244ca1f04d350adfaa6dcffb7b10782a312023f74433a913abd7de0ba42914"
    sha256 cellar: :any,                 arm64_sequoia: "9b4320b11ef0298666c47b393c84a5f6b12df5bd2e75cecfbb68929bb94d4142"
    sha256 cellar: :any,                 arm64_sonoma:  "9b4320b11ef0298666c47b393c84a5f6b12df5bd2e75cecfbb68929bb94d4142"
    sha256 cellar: :any,                 sonoma:        "5d47a71cf5748c96dfc0e275feb7762dbb803cbf613d7300257cd4ecef22d03e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227df43370e42e88f4f13836e5d62a7a59bc37b9f62d8ceb3b9f6d1fbb1f2011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2447a0fce182dcb96c6ca6f91e8f615870de673e5be52f785dd1fd66ab3d0398"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end