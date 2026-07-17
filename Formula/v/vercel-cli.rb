class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.2.1.tgz"
  sha256 "be9edd705e29de8ec095215b8b2846f109da87403dc3bb61237854500d00c48e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20cff29e56182e1de5e6769a6763dd17d5054c692f6981c75bbd1de764440fd1"
    sha256 cellar: :any,                 arm64_sequoia: "20cff29e56182e1de5e6769a6763dd17d5054c692f6981c75bbd1de764440fd1"
    sha256 cellar: :any,                 arm64_sonoma:  "20cff29e56182e1de5e6769a6763dd17d5054c692f6981c75bbd1de764440fd1"
    sha256 cellar: :any,                 sonoma:        "0ef1a49b7d0e4966bbe3c89544ca25681dc3ea30aa4065ab0968c80e602d3037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5928a66a117cc7a78fd1fff32f05c58e2b86eb4ef9441a4298ac29f4b5d416b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985b4102e9278b01f846e90e74f69b1c0e3829ab8bc2664d7d1ad9efb56848d5"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

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