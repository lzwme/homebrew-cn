class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.7.1.tgz"
  sha256 "098a27d01d6acb50a2e5896ce2ff03c6c7c773befdfcb9ec9795ed96b04f9af3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "277e16e8935617a283b4ff62d572b9b51f4bc4cbe82bfce1b94ac7388e32a7db"
    sha256 cellar: :any,                 arm64_sequoia: "fd530a10c46a43b67438240e0ae524b210afc0c9ebe83bc2f03fe709af9179a9"
    sha256 cellar: :any,                 arm64_sonoma:  "fd530a10c46a43b67438240e0ae524b210afc0c9ebe83bc2f03fe709af9179a9"
    sha256 cellar: :any,                 sonoma:        "d890bcb35b9b175b22c5f1bd4b2572abe0caa4699a73a26ad93a33933d87a151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a8a751c7eef64ac9242565ea8bf79cf2b9d00b77bbb292bb9c764bfd45a5e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79378b5b6ae9b2c13d6141bbebd70fb02d465b28c314872d801f0cfd07c400c"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end