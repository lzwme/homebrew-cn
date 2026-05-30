class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.6.0.tgz"
  sha256 "e4c2dfd479009c3a9bd2f2076b03ea2f69975d83bb95388868ce50a6e3bff004"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e85fc255c30bbdd645dc065c4d40697052c2bbd927af206423bceaa78fb7376"
    sha256 cellar: :any,                 arm64_sequoia: "f04eae472274ac6d7c7ca1c08b7056f66fd6a4fe7de6f2e9903fb6c05aa6f4d4"
    sha256 cellar: :any,                 arm64_sonoma:  "f04eae472274ac6d7c7ca1c08b7056f66fd6a4fe7de6f2e9903fb6c05aa6f4d4"
    sha256 cellar: :any,                 sonoma:        "610ea2707b5ae7c973f67a610a8e5eb75fee74e89e396f15d5847ef83a1a59a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f5d9b2cc89e094a98a39aa6ad5f7da6af4bd0944cba1eabda693095f0d2c4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e828b85d0f939643d9bc3b84aba5a7fcbb741967ffd2176e94908deb7f4a9d39"
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