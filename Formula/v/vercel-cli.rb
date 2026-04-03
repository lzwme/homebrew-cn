class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.38.3.tgz"
  sha256 "d92f51247c7d7930677becba41382a9527963de0c5801b6047324f0b47475719"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32e807fae19ff0da1adaf3f5946a727843b9b053b1678adddc10a0b7c1cc6897"
    sha256 cellar: :any,                 arm64_sequoia: "a78b18d76af526e2631331f36a72a4197fd8ff4f73ed951762a4f11c2022831c"
    sha256 cellar: :any,                 arm64_sonoma:  "a78b18d76af526e2631331f36a72a4197fd8ff4f73ed951762a4f11c2022831c"
    sha256 cellar: :any,                 sonoma:        "febbcc7a656166ddf901d0ea68ecf699f68f8b98b975795dbbd7c7ad6b1bcadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd16fe2ec71dc8b86e29009781aeb13985d57cca6e0769ea13500a8b23a05db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d14d327644738944b43f6c734e3c9d05b1d4f6ae699b8d9c66bd95b9c050051"
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