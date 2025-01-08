class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.2.6.tgz"
  sha256 "245f937584d61d041f354166b872e9e985d81d61287fe5cbb80b8818a13a1b45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2f339783c8c66a4ae055dccfedfea6ee1afc02d5e33047e799cecd4189234f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f339783c8c66a4ae055dccfedfea6ee1afc02d5e33047e799cecd4189234f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2f339783c8c66a4ae055dccfedfea6ee1afc02d5e33047e799cecd4189234f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e811d5e3912065cfc6e1a27802b33f6a7c34b82ac09edd90c19ad287f1c4eecc"
    sha256 cellar: :any_skip_relocation, ventura:       "e811d5e3912065cfc6e1a27802b33f6a7c34b82ac09edd90c19ad287f1c4eecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4a37f0f3d79dd3490b9c8d670984d1d874a34e94830f5e7202eff1499d47fb"
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