class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.0.2.tgz"
  sha256 "60abe074ce2cb2bb88c8f2668ba4649182de3fc9960f4c8c435d61de3996e2a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fcfd414399baf687f75801c9fe620b0b04573a529d2a3b70ef5cda7d4fff5c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fcfd414399baf687f75801c9fe620b0b04573a529d2a3b70ef5cda7d4fff5c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fcfd414399baf687f75801c9fe620b0b04573a529d2a3b70ef5cda7d4fff5c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ed099df29a0e0b8a504b3a369d382b69a0ccc09be1650a8959a81e9cc2b68a"
    sha256 cellar: :any_skip_relocation, ventura:       "05ed099df29a0e0b8a504b3a369d382b69a0ccc09be1650a8959a81e9cc2b68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b3c8bb4448835c3646676ddb3e523f1f53c5573d82db4fdb9ff3ad39682c04"
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