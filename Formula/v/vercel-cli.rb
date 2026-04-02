class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.38.2.tgz"
  sha256 "f1f717709d72dbb64cbfc1374fa0aa8328fe9bb7e388c69bfab794c976427cdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5eb270a42f519990940fe5cfb5e751e92a7dcf6a2fe770e0b61071c99ea52d2e"
    sha256 cellar: :any,                 arm64_sequoia: "805cf77f3ebc6a658ff5aa7d0f3c928a784efa2b626da38f45b7dc8d68bc71a7"
    sha256 cellar: :any,                 arm64_sonoma:  "805cf77f3ebc6a658ff5aa7d0f3c928a784efa2b626da38f45b7dc8d68bc71a7"
    sha256 cellar: :any,                 sonoma:        "53c83c666aa8f3d5bfa9c329dd2dbeb5526962c99097ed7099a9407e683444b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01a0a938a02e229a0e381697e206f65a77632e95d97f251b26384a093941bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb88fd3ead182357f84a0b5fccbb329f5cdbdb61bf74e74d3dcf03c0c859865"
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