class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.7.1.tgz"
  sha256 "6f0c25f56344e4c9e0e455d7c56cac10e3440796b9b997252b8f4bddf956d1c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d06197194459784ba71bed02e5893c01a0c2589c493c0c92e4f0617d4dccff09"
    sha256 cellar: :any,                 arm64_sequoia: "23f7b5800661aa8259bfb4cc1a854836c558964cb6267460d688f275a89bea30"
    sha256 cellar: :any,                 arm64_sonoma:  "23f7b5800661aa8259bfb4cc1a854836c558964cb6267460d688f275a89bea30"
    sha256 cellar: :any,                 sonoma:        "1044b9fc9efc6bf87e8c1b1843e1a37d79e3747b7140e96522011a618e750748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a6c7c9b51845adb89988bbcd9afaf5570d7391b5e28d395650677051d838b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d0eb23a37c45191ef4361c02291ad7c6b232a599435ee163b539b8fbc06f4d9"
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