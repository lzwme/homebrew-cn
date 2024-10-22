class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.12.0.tgz"
  sha256 "e9c6751885cdc7c7861c63cd50015e1e1571b9720752f6bfdaf305cfa1dbb2df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23da3a39b9d12e066702508d8dd2ad1600c971700401443482530f06c05f542d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23da3a39b9d12e066702508d8dd2ad1600c971700401443482530f06c05f542d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23da3a39b9d12e066702508d8dd2ad1600c971700401443482530f06c05f542d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14306d6c2773c3150123d8c669de9dd5d54fc66ce21bcc45f04c416e09483775"
    sha256 cellar: :any_skip_relocation, ventura:       "14306d6c2773c3150123d8c669de9dd5d54fc66ce21bcc45f04c416e09483775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b75c1c25c0e34cb84d28ba32dcc2a3d19da1a005fe63f988b0b2c3b706a271"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end