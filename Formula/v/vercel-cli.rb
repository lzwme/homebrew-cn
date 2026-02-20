class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.22.0.tgz"
  sha256 "1b67edc2d0deb01019303a06f5b9cc9878200114be61f1c325787b6ec03995e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7bad50b31c3e2106ff30070644029f66d07dbd19d3cbc5ccd8bf88512b81f24"
    sha256 cellar: :any,                 arm64_sequoia: "0441617d82fb4db3d16d96d824b65d53d3a07e88b4c6c6171cc918376d55ec32"
    sha256 cellar: :any,                 arm64_sonoma:  "0441617d82fb4db3d16d96d824b65d53d3a07e88b4c6c6171cc918376d55ec32"
    sha256 cellar: :any,                 sonoma:        "6000f6c71f69e557f3cd9d5690f9b653510338452cc71b117cbe2d61fdd2b5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de2a85df7505389ef4c9df627fe3b4fe36ae3849adb279805a7cc43f9b56f43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fedcdff86e74db20225889b8d552ccc52d9d14e76b90fa587e02763e16e0f6b0"
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