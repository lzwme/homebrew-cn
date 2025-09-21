class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.1.0.tgz"
  sha256 "8e0c38ba67b03322abbc2e6000f86700348fa1cb69aeabb361a605ad905bb1fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e33c0b17fbebaf1e9376399708b5f6bc9af07539dded43e703508dbd6f1f85e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e33c0b17fbebaf1e9376399708b5f6bc9af07539dded43e703508dbd6f1f85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e33c0b17fbebaf1e9376399708b5f6bc9af07539dded43e703508dbd6f1f85e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7258a78895ff4ebc598d74dd063c8e43e11a0bac8491236142775fac320bb875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650e33fe3994b2aa6cdf7221865ac56b0a9d26cb7c9a3c7342dfc15fef2c2a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "787d5e9b816e3c744e94f6039930b9486378e44b3ba65b6f5573406d7873566b"
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