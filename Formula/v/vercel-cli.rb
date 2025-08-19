class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.0.2.tgz"
  sha256 "70a94d00e77761584e3581d86cc61f79f42993708a369a696edb370b7c8e9ed0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbd3b8d858cf71f1d2da10e114e40ba6ff25286ace08d86e0288c5f76ff4343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbd3b8d858cf71f1d2da10e114e40ba6ff25286ace08d86e0288c5f76ff4343"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abbd3b8d858cf71f1d2da10e114e40ba6ff25286ace08d86e0288c5f76ff4343"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d81b4ecc81f8ce7ab087304ca1ff935809f5ccdba0fad0df56c540425cd4874"
    sha256 cellar: :any_skip_relocation, ventura:       "3d81b4ecc81f8ce7ab087304ca1ff935809f5ccdba0fad0df56c540425cd4874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b543351385e60ad021a85a0c18bf706b5d944048ea555f38a1ad08e15a051102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d806017b2386b116d05fc13153b7b5b3ed44936f3b9920c1d29c60247eb1850a"
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