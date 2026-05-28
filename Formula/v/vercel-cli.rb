class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.5.0.tgz"
  sha256 "9acb167c26dc7778af1e8e39d4d42498f491924b7c3637dd247d9ceb172cb273"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35db9bc80adda2c0e5cd45c8389ecfa518208673d1ac47f2da381b7b34e7081d"
    sha256 cellar: :any,                 arm64_sequoia: "4681386f2a917949749f05560cbfd5340d4a0eb980be50fcc67e6f97545b998b"
    sha256 cellar: :any,                 arm64_sonoma:  "4681386f2a917949749f05560cbfd5340d4a0eb980be50fcc67e6f97545b998b"
    sha256 cellar: :any,                 sonoma:        "4327410c806f7c75ec182e9d040edf3e27f8269adad51ce5315b8a39468e07bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f7c831c7937261890cf01bc234b18c844e58d362652115559743f6d5d04213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7007a20637e097ae663fbd7139a3461fa6f3d9758108b1910824b35e2cc206df"
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