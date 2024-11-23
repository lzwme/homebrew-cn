class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.1.1.tgz"
  sha256 "e4114435321357f31a842d242fe2f3808e3255770b5d09046f7755da6da45f70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cafdcf2098b3c8b8c99219c31ecae4711db9b4bc0efc68e5660e3502df30016f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cafdcf2098b3c8b8c99219c31ecae4711db9b4bc0efc68e5660e3502df30016f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cafdcf2098b3c8b8c99219c31ecae4711db9b4bc0efc68e5660e3502df30016f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2d7bce31cb122c36024f398a028d7018fb88802a7dc2da218094a0ff84bcaf9"
    sha256 cellar: :any_skip_relocation, ventura:       "b2d7bce31cb122c36024f398a028d7018fb88802a7dc2da218094a0ff84bcaf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1dc2760a7f577c6c07495c53b812729fddc8bb2f1d1024620478a5444ed9e6c"
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