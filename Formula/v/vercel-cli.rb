class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.1.0.tgz"
  sha256 "509b03c2cf934c9cb2236e29f72c72d33d4ee97138da9e5fdda7a9f5f8a0a5df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b74ac34dd952797eef3a5cae27c000a8142cd5287236f4e5223efb3f8084b1f5"
    sha256 cellar: :any,                 arm64_sequoia: "be1140042a911dc0e9a9cc24f2f014cfd5c3afd9355063939d1c5cf5c77c90bf"
    sha256 cellar: :any,                 arm64_sonoma:  "be1140042a911dc0e9a9cc24f2f014cfd5c3afd9355063939d1c5cf5c77c90bf"
    sha256 cellar: :any,                 sonoma:        "2d2a6ceb549a77dd9e6de48b519f25409ddde7d15c454943b5d54ba7ca7b145c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ea986045775757d109f2a054f86eb2bcea6c02b4d0d3ad755a8854c3279431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e66c24dc4f2bcefc1acaf99363b90d0e1dbe47945d7e59780bd0296b4e36800"
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