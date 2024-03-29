require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.6.2.tgz"
  sha256 "66cf9a4bd3f8d0ac76be5843c03427f643e7e88e17a9af96b0bb2c6e064ea58e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "119787853e7be8c47f7b5be06349b394e573cd6405d2d665c618f8684fb28049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "119787853e7be8c47f7b5be06349b394e573cd6405d2d665c618f8684fb28049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "119787853e7be8c47f7b5be06349b394e573cd6405d2d665c618f8684fb28049"
    sha256 cellar: :any_skip_relocation, sonoma:         "98d1b640837ae2778caa9bd5e9735becd4cd874c80c31fb21f192133abe036ff"
    sha256 cellar: :any_skip_relocation, ventura:        "98d1b640837ae2778caa9bd5e9735becd4cd874c80c31fb21f192133abe036ff"
    sha256 cellar: :any_skip_relocation, monterey:       "98d1b640837ae2778caa9bd5e9735becd4cd874c80c31fb21f192133abe036ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076a7d9cd21342a128a95a9f97138a80fbbc5ab0ef02566ae749d0917ad483b7"
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
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end