class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-43.3.0.tgz"
  sha256 "a2b6d15841665c6716d2db722c6ea56864e8f6b1373004ee6d69b11cc823852b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d924f2171fbddd363f8ce6b647e66b30938e0319a82f274ebeb03a6c3ddaf78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d924f2171fbddd363f8ce6b647e66b30938e0319a82f274ebeb03a6c3ddaf78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d924f2171fbddd363f8ce6b647e66b30938e0319a82f274ebeb03a6c3ddaf78"
    sha256 cellar: :any_skip_relocation, sonoma:        "286f8f9d030b6964170b28b679cf6c96bf0c8dff4415c13ec2a79785c10f8eb1"
    sha256 cellar: :any_skip_relocation, ventura:       "286f8f9d030b6964170b28b679cf6c96bf0c8dff4415c13ec2a79785c10f8eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3966752416ac812706289128088022c3be35206c8b9464fee29f8fe2c5b98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc23ab0e8e800408be4988ea18212784f667ed6eedd4b29f99f2255199c6acbb"
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