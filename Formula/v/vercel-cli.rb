class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.3.tgz"
  sha256 "b9bcb0cb33a0a6a7f797850baf54b6129339c13bd8622257dc3d495554a19374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a89e8312397c2202f20100d09c1a9af68fecd80764b9678b047e7ee53cbb878"
    sha256 cellar: :any,                 arm64_sequoia: "f402275cc5049db6cc0e71296ce1948c28a0f12f440c1e3b74f5db7a6221d09a"
    sha256 cellar: :any,                 arm64_sonoma:  "f402275cc5049db6cc0e71296ce1948c28a0f12f440c1e3b74f5db7a6221d09a"
    sha256 cellar: :any,                 sonoma:        "f27e02d23b9f8775a5a9a32a1603596a4f0e8e8ec268001f3074ad7f4835a12f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "888c41f5b95cb5635eecd79ead1829fb33f8a1d8e0187b6c4ed7fd8e8cf9af3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52ca59e4cc59c52cfd9ec2789e3cadbc0f559b6b0fdd52b16e943e8c2fa291d"
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