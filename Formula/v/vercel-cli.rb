class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.4.0.tgz"
  sha256 "725b5e34f45b8908a5813b304d7cd76034d0cda30a46a3ed21f73c527d21c14f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82b9ed6b7391c0c8cf564d9bcc653206ef61d227c80f92df7fc26e5e5a9c1f12"
    sha256 cellar: :any,                 arm64_sequoia: "025097dd9a1142f566e389bd29977f033d9eb1bbafdabc0fcd8cf3401aaacb6c"
    sha256 cellar: :any,                 arm64_sonoma:  "025097dd9a1142f566e389bd29977f033d9eb1bbafdabc0fcd8cf3401aaacb6c"
    sha256 cellar: :any,                 sonoma:        "49be78a02323562cb7aea051ccadba1bb8d829ed868eaa2fc52a21bece561379"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf259281aa5aed2aedab5b85da641979662067e7f62555a3dbe58103ca59922f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcefbd20dff81a08763f3a377c0c260e6aa37caf26bcc440dbc9f24dd92f4a1"
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