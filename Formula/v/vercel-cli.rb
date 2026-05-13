class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.4.0.tgz"
  sha256 "fc7927678cd99305f5cbf995d0c8f700308c25b9ce4032476d74246dae3ad27f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e6b7b12e84cb7b93faaaa6cab72eac3346675a7a034bd301a25bd82ae51297e"
    sha256 cellar: :any,                 arm64_sequoia: "b79e79a2734a25bbc1167c5f512b58cccf74f85fa6c63ae37312516f8b9d3452"
    sha256 cellar: :any,                 arm64_sonoma:  "b79e79a2734a25bbc1167c5f512b58cccf74f85fa6c63ae37312516f8b9d3452"
    sha256 cellar: :any,                 sonoma:        "1b3c13e8050e45486a300ff9eb9327490dff46f935ef164935a9df1068c74954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18dcb1dcac3cb5b1fa77517d8ce87b9e216e4a91e228bb47a9b23de5d46fe6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9404f9404ad3f244402ecbe3dcad88b28daf156c23cea419da8869c45a7498"
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