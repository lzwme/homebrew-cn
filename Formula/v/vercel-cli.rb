class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.3.1.tgz"
  sha256 "f1c22b2733a41a7dbf4b4576fb02244454ca45c1ea33aefa43cb1d5278759ce4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e0ef6acf294281f5fa1f552c516255b370ac5989dacd97ef7060674c09f72c0"
    sha256 cellar: :any,                 arm64_sequoia: "b0740a65012b5f367f145767c88a55d3fd655bc2fc5332ab906e6c2d2fb35e6e"
    sha256 cellar: :any,                 arm64_sonoma:  "b0740a65012b5f367f145767c88a55d3fd655bc2fc5332ab906e6c2d2fb35e6e"
    sha256 cellar: :any,                 sonoma:        "46a22d29b1390b394e6284d2eb44459d14d97903c16495530f95487525415c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b1d6e23c731b43c6f159e0d199ab8cec98a9520ab138794b60a8d8f6739e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590ffaebdfdb7b4fe2b984d7e31e81f73fd4be398ec630b171d7a8d401b34d7f"
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