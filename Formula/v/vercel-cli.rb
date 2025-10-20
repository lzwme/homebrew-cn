class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.4.1.tgz"
  sha256 "bfb74b41abd34a0244256b70166dcb11e8ccefe9f7621a570a2aa64788d5b0fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25b61f73ac86298977354a6c5dd3e62b6b12bba7fbf365efbf7e717c1f1a88da"
    sha256 cellar: :any,                 arm64_sequoia: "fa7ff87ef6b3a86688d9708ec53ab76b78ff974d19795f655f2578c68b32e52c"
    sha256 cellar: :any,                 arm64_sonoma:  "fa7ff87ef6b3a86688d9708ec53ab76b78ff974d19795f655f2578c68b32e52c"
    sha256 cellar: :any,                 sonoma:        "90c6c3873e63f2b7cff2dd838dd00834c4259dd0f81589912095d879e4b96cdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1355758cba806dec2f35f2e40e76d9383c596e78f8c075bad36ed9b4d8e51b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb893a54e95209e02fa2d20ec67dd9ad9960f4f3f16e576a40e06c15e49172a"
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