class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.20.1.tgz"
  sha256 "7095ab0b2fe3ca6deca05b3a971b4589bd518e4c40262945a89be24f7abb4b92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c414b61bf4696f74ceade1afc8df8470bf853c4a11bdc6beef8bc10b2d8961ee"
    sha256 cellar: :any,                 arm64_sequoia: "d80d4f38ed4ff14dd0edd34acaed5fe7ff5f58e44eedef62f931d098ced036c7"
    sha256 cellar: :any,                 arm64_sonoma:  "d80d4f38ed4ff14dd0edd34acaed5fe7ff5f58e44eedef62f931d098ced036c7"
    sha256 cellar: :any,                 sonoma:        "545c8dd1e7fa826f005d7b2f5dcc3959d9d9e3e7d6973316431e093fda398cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b041e3588e1a31318bba77ce392253b4f13a386004bc9682343c5cace897b43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762b02f2b844e70a3e9f09ccb10ae9916f8609992233f9204c29b280d8bbe36b"
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