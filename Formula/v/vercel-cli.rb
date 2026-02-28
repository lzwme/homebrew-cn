class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.3.tgz"
  sha256 "a02ac064dc9ff31b5acd0cd8d3048d2c6ecc061e4f101bcb53dd9b5bc41f844a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "decb05bedd460ebee8331ecac888f3bf29de9dd3a9d1f8723fad54efff1afb56"
    sha256 cellar: :any,                 arm64_sequoia: "971d477580f1c7b073089caefc8429deb89c938320209f260c0dd4a171a0a236"
    sha256 cellar: :any,                 arm64_sonoma:  "971d477580f1c7b073089caefc8429deb89c938320209f260c0dd4a171a0a236"
    sha256 cellar: :any,                 sonoma:        "1e72568727e60057c052c0f3a734344d7d639803ff545b2808c6dd49b354a111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed1da67411958f64241a8c43da3083fe35f78bc845f36d4cb8fd11f163d20d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff98cc1060a7e94baefa0d823aaba7550a324a3ddb9c95abd70042d3b0861eff"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end