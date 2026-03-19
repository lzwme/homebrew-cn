class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.33.1.tgz"
  sha256 "5b2eb056024bf1a702fed39825041f9b53379bba1ac8d2963c72390f329b7bb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c20e4f4b14c8805e70068fbaa58e5965d69c861a4417331ff13844020686ab8"
    sha256 cellar: :any,                 arm64_sequoia: "3e75cf148897b75f3c50d4e63295a9397db76c15946ef9ced1875943ffe5d708"
    sha256 cellar: :any,                 arm64_sonoma:  "3e75cf148897b75f3c50d4e63295a9397db76c15946ef9ced1875943ffe5d708"
    sha256 cellar: :any,                 sonoma:        "cd9123bf728c8c6a5b2929b2ca82adf77f70dd7db61c236de95f99c00c500443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84fae16bcaecd663b7b0b83adec543e5dabfabcd1fbaa5017c07386c43735476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1a70025bcae45bf9c6507e9af9f7755563575e116699ea1b62fda705cff268"
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