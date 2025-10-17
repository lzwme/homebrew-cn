class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.4.0.tgz"
  sha256 "744c88c966addcf1767a90a2c7691b666fd62a9f7af2cba2df4870ac79bdcacd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68aea528315642ee8904e8138d2a901011eea97d19ff32209b3ad7da9b4886d8"
    sha256 cellar: :any,                 arm64_sequoia: "778402cc2178517c3702156403ee8cc2ca5dd0acb52bf41d0fb20eab1d7b47f6"
    sha256 cellar: :any,                 arm64_sonoma:  "778402cc2178517c3702156403ee8cc2ca5dd0acb52bf41d0fb20eab1d7b47f6"
    sha256 cellar: :any,                 sonoma:        "64137612b9bef2a303dc139ddbe745c3fd93011d2d17d5265636c5d0b70b66b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f956c55e06930dae28df150830310340db486fa2ed55ee2245fe37a94ef60996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfce82d5ce56e5144a4c9230b4d46d04ef215e16d9ddad66345838ff6e358416"
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