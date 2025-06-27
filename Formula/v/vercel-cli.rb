class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.6.tgz"
  sha256 "fb9b21a03167574990d65d99ce9eaebedce986a37e2b371592009065fb8a0656"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec883c50683f3c69381289f800164c156b17a20e9214ca77fb5869c3a5039831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec883c50683f3c69381289f800164c156b17a20e9214ca77fb5869c3a5039831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec883c50683f3c69381289f800164c156b17a20e9214ca77fb5869c3a5039831"
    sha256 cellar: :any_skip_relocation, sonoma:        "87cb3aeeea9743f5d5ea4e82696422564c52f3316368eabccd289a716efee3f1"
    sha256 cellar: :any_skip_relocation, ventura:       "87cb3aeeea9743f5d5ea4e82696422564c52f3316368eabccd289a716efee3f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ee0cda3bc608dab29c8acae5dd0e6084f566a5f8478cb1e47bfbc24d0c2088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2978b1de1dd41fbac594ace353c94849a083835384cbe15902ec47a8f1e7c90"
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