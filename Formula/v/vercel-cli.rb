class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.1.4.tgz"
  sha256 "0b21a877dee37250308de7e558e5673d535f5bb8a18aed50c7b483231e1ae4cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d53b4c4db4365895f0340209bdc501c4cc2a3d6242374c5456a180d6c46d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d53b4c4db4365895f0340209bdc501c4cc2a3d6242374c5456a180d6c46d67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24d53b4c4db4365895f0340209bdc501c4cc2a3d6242374c5456a180d6c46d67"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a98d157a785d650fe2430b330188a668b11eddc33b97c1c431665330e0a336"
    sha256 cellar: :any_skip_relocation, ventura:       "b8a98d157a785d650fe2430b330188a668b11eddc33b97c1c431665330e0a336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79bf56de5e1e9abffb066d5404b6fe331ab6d05efd539321014157e5bb58cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ebc2d9d722e3afaa941b51b9982708ce31beec5b9d8b9b732eabecd98e9fe8b"
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