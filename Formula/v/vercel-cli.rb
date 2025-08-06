class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.7.3.tgz"
  sha256 "f4cb475e63e0fb3b554cf465405a8963a8ed0ce0b77dbe9ac7c720c6413ea88c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2728c10169e5900f354b01feed34ffd9668baaa0f1ec4efad26ac267ceb29680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2728c10169e5900f354b01feed34ffd9668baaa0f1ec4efad26ac267ceb29680"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2728c10169e5900f354b01feed34ffd9668baaa0f1ec4efad26ac267ceb29680"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab28cea42a65de34e450ea54a22221fcaf7d358b2a86f3ae1d45d2ac914c493d"
    sha256 cellar: :any_skip_relocation, ventura:       "ab28cea42a65de34e450ea54a22221fcaf7d358b2a86f3ae1d45d2ac914c493d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b1cf2f85add93841a86cc8fc902a8b30bdba9fe7ee3fa12aeea58d22918012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5390ea6c1fdb381175a69aeec7a76ece07f70c516b579ab0e035f378ea188d8"
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