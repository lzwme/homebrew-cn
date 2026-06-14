class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.13.0.tgz"
  sha256 "756284f2b832a8c1526d666e6aeae556090e4264fbf43dc2e1bc92844c248017"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa83c859db71594a3194b71951fa667a29f0c93ea7bb8c50fca04cd3bfbaea31"
    sha256 cellar: :any,                 arm64_sequoia: "d7e165ce6cd4deddb3a48c971c24159d18463f9a13434092898096a69dc98cce"
    sha256 cellar: :any,                 arm64_sonoma:  "d7e165ce6cd4deddb3a48c971c24159d18463f9a13434092898096a69dc98cce"
    sha256 cellar: :any,                 sonoma:        "1200409f4d1293673d373c74b2512c47aa07a5fe279b3da11628b5592b388494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e694f3ef61e7044a9d8d7811a397fdfadca04a78f3e01e9f1cda74f847b1435b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a146b152b39f6d02ed7fdc49c77a4a0654ea1c6b0d5e3db309a274a3814c1e33"
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