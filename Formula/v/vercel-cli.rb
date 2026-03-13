class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.32.4.tgz"
  sha256 "9df9d2a5c37d5277d91e2925df19c4fc856f3b905a9d776fab04935338feafb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6eadb6c79eba813c6b0ae88fd714a05904ad0212a8b03aa98d66572d3c09e3b5"
    sha256 cellar: :any,                 arm64_sequoia: "016b7e918670be7ff6d29a8ae36f016f775ec4f05e48496665e1a9839d55f43e"
    sha256 cellar: :any,                 arm64_sonoma:  "016b7e918670be7ff6d29a8ae36f016f775ec4f05e48496665e1a9839d55f43e"
    sha256 cellar: :any,                 sonoma:        "eefcad6438ad12d93a9f7d9a0ca20ad8d039fc3e3d6521745ed66e4cd5cb632a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d721a768ff7e3b99b83eef7d360de92107654b6f0ba5c9bdc592f13773b268ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a679135d0c9e6f18a96e59d35ab468620d07b1b061a960a87e06cf2031900add"
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