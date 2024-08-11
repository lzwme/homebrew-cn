class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.2.4.tgz"
  sha256 "8065dd505a7427c297fa26db7734f94ad32ee66251fd97984f51e137f0e2d6ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "699b9864c8fd63a25b347199d7e405916999a15be33661f9924075fd3f32b91b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "699b9864c8fd63a25b347199d7e405916999a15be33661f9924075fd3f32b91b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "699b9864c8fd63a25b347199d7e405916999a15be33661f9924075fd3f32b91b"
    sha256 cellar: :any_skip_relocation, sonoma:         "85ddceb747c0817f3776cce9bcfac2514ab2e64a45685cbb128264de3ab3ac5c"
    sha256 cellar: :any_skip_relocation, ventura:        "85ddceb747c0817f3776cce9bcfac2514ab2e64a45685cbb128264de3ab3ac5c"
    sha256 cellar: :any_skip_relocation, monterey:       "85ddceb747c0817f3776cce9bcfac2514ab2e64a45685cbb128264de3ab3ac5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ad37d632b78ff2980db424b9355885c32bc7544e9a2fad7b0a071c65e20b16"
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