class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.14.0.tgz"
  sha256 "f4419858822a4d107aff6fe1c90c58907f2bb9fb2928c1bf906b31ef3cf82f34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5ad35ca094febc7878118c117961f2d7fe8f699576705371eeced045d291ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5ad35ca094febc7878118c117961f2d7fe8f699576705371eeced045d291ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb5ad35ca094febc7878118c117961f2d7fe8f699576705371eeced045d291ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0b98f0a70180665ccabd5c7c5b64467f4bee9fefb6ab9c4f05abba908912af"
    sha256 cellar: :any_skip_relocation, ventura:       "ed0b98f0a70180665ccabd5c7c5b64467f4bee9fefb6ab9c4f05abba908912af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f8001f1705246252699b87ab5bfec09c3c621e9502df3f8c09832e7b1e6306"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end