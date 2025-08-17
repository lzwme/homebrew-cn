class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.0.1.tgz"
  sha256 "6687db7baab3f92b0d3e44fb38323968f03da7af65122f47b2748dfada7f1cbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e835653dc3198358f986f8a1607cfb379498c1a81b42e8332c21e766b08efdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e835653dc3198358f986f8a1607cfb379498c1a81b42e8332c21e766b08efdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e835653dc3198358f986f8a1607cfb379498c1a81b42e8332c21e766b08efdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "735e77cfa8fbfc511aea43a831ef1d2909c275a65921b65d76327e90f5dd78f8"
    sha256 cellar: :any_skip_relocation, ventura:       "735e77cfa8fbfc511aea43a831ef1d2909c275a65921b65d76327e90f5dd78f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c34f56f0f4940e3579e8cecac61da0788dd93fd1d059a6db179d13954f307d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a2524502a241e96faf6fddd7da954fbb52603f7d6431b6c7a4921fdd038570"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end