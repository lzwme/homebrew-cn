class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.15.1.tgz"
  sha256 "fd6f658204b78a490b3ce26f1f1a0ed55247dc557c18a3e4cc77db4cf0cab4a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01c40d5a6e348a6587f547211de815c6bd7c9b912a966d4bd3ff6b54e7dade91"
    sha256 cellar: :any,                 arm64_sequoia: "d311bf1b6da6b3de044e678ff3a8a1d12adcf9dbf3b6f510afa933f8c6e98b64"
    sha256 cellar: :any,                 arm64_sonoma:  "d311bf1b6da6b3de044e678ff3a8a1d12adcf9dbf3b6f510afa933f8c6e98b64"
    sha256 cellar: :any,                 sonoma:        "bd97539a55bfcdf728fed3aa6c7f8187f53b6063a7694cf6dcfbc84ec6a2a923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "617d0863a65e2d5f3877d1a0129c263f52bd374db84fd7c3b397deb0de1ce422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d1c0f99027fb56f9db1edf7159c265d7770b62f2788a0484bade82c4512ecf"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end