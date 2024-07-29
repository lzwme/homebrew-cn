require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.2.1.tgz"
  sha256 "3a5051784b005534d11b60e4f956ccd4d317dd172204f0f327a1d1cb50fe8f1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff51372af13b109b12c7eef638332b786ab2e2287cac95a3b7e978e794d60b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff51372af13b109b12c7eef638332b786ab2e2287cac95a3b7e978e794d60b1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff51372af13b109b12c7eef638332b786ab2e2287cac95a3b7e978e794d60b1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "465921fd18272d4d27e0abac0cacd371ea6c42dcdace84b26fec86172c545fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "465921fd18272d4d27e0abac0cacd371ea6c42dcdace84b26fec86172c545fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "6f6d7f9ffb409d3c029dffe6d289a4b2cbb84dfdf7951da3c52ec7119ecbb36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd311ab68e307887a31e5d3f07e9ca265075d1dce5b7a995e7c0a52b29295527"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end