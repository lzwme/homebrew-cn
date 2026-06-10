class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.10.1.tgz"
  sha256 "23dfadeabcfc5774f5ccec608640da1d1d7f51d82ad02f897ba78cd5a0b8e509"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4576a793bb940a34680c5d40d1cb5ad2dd4981157232f30dd91616b783008859"
    sha256 cellar: :any,                 arm64_sequoia: "85c0aa0584093d3268d2577027fd9ad6ad26c57c3508ffa026c71b7c6ae6b595"
    sha256 cellar: :any,                 arm64_sonoma:  "85c0aa0584093d3268d2577027fd9ad6ad26c57c3508ffa026c71b7c6ae6b595"
    sha256 cellar: :any,                 sonoma:        "e8e907d95bceb818973c67a99445d247e78aabf5b472e9d0036629d71413fb36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43c6c8e8c7df7cef3f168c77ce1a04e2c20f196b402e7f74ea5a83964cc7cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df8cf6c6cc56934a77483e44b27a95d22c75d8c7855b27df8b70d2aa96ce038"
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