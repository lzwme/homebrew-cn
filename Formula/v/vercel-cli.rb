class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.7.tgz"
  sha256 "ab33ca8c3e434fce7e40c4e6e3a1d27426a0a2aff917c5054bc44d1f2d0dbdfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9d14f882658c4f88ca2691afb2bdbd07c2f59838ef247b5cc022496f0017df5"
    sha256 cellar: :any,                 arm64_sequoia: "adea5e2a18419849cff3b6f5bf23c428152c6917c315a75af1c227b2e81ed275"
    sha256 cellar: :any,                 arm64_sonoma:  "adea5e2a18419849cff3b6f5bf23c428152c6917c315a75af1c227b2e81ed275"
    sha256 cellar: :any,                 sonoma:        "fb5e67532e5f70615ddcb2e88b43ac7918ffaec78f0296ad1b18f30032b14a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c45a3bad757dfb3464cee10dae822cfe1f7c78e109ca1aeeb091052d1122f258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3700d75a756ca595d47c02774fc21762b788235d9ee443cbf8470b2ac5e8674"
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