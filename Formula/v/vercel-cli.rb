class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.28.0.tgz"
  sha256 "09377384ae64ad1c32477833c82573a6d737edb6fe2cd11af3a8c1ff1254cc29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "340e6b4b1d840ed5ec7d337f25722e3879b896dbaf39569905a29da032560d27"
    sha256 cellar: :any,                 arm64_sequoia: "3ea0102ffa73a5281f4696332fdb996e66352abe7f16911a910536acbf6aeb0a"
    sha256 cellar: :any,                 arm64_sonoma:  "3ea0102ffa73a5281f4696332fdb996e66352abe7f16911a910536acbf6aeb0a"
    sha256 cellar: :any,                 sonoma:        "fe763ca3c3e0eb65547101532475716395d6eb736e2f70b748872db4bad53ae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bc03717c30173ae1c6b8e5c41728a942f0236a14c8a1d3066992193172f61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa57fbccc29d36d7ca69c35f12069a157186eaf188c128dd1e8dbb36f916654"
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