class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.5.1.tgz"
  sha256 "bdd8652f4cc9b8d2774d122a6be7dba950b6cc0c106b8309fa1ade5405ddc549"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7a9b0785a3c16a426daa03e804bc2f4e8aa6639fa841766c37c83ca91d3d9f0"
    sha256 cellar: :any,                 arm64_sequoia: "63bdf18be01e30e1425c345081b13dcdfe72b50ed9940e0fb71edf66ee7c6502"
    sha256 cellar: :any,                 arm64_sonoma:  "63bdf18be01e30e1425c345081b13dcdfe72b50ed9940e0fb71edf66ee7c6502"
    sha256 cellar: :any,                 sonoma:        "dea45ddd29f20a177fd2fc42cfe3ee96a89a97aaf6825a21b57a715c20d15932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd5c204894b47dbebead3d7941f5541233ba556575a4d49a0dd6ae37183d1052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d43c7204769bcea517533666a78ae2393a66d473dde311525b143a18d3e5c8f"
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