require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.3.tgz"
  sha256 "b3d793afbd9fb56375896a21684b0dbf272cd341e8e85778091d5e188519ddbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6b0436972df69df0d79465e6fd08b0cb3438cbd97e037969f8888a8cefbc00e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12ea9eaa6728457f26579276527cccc3a303c7f1611ffa99a4612eb6bd817f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e1e074d09e423e8fcbebc51d346133d0b77c4f4d244166707e6cfeae58e546"
    sha256 cellar: :any_skip_relocation, sonoma:         "b53b9330161708c2f5927e3918dbda9ff40ede58b9f64406c3c11096580bfe3f"
    sha256 cellar: :any_skip_relocation, ventura:        "e2c7140bd95e03ce4abba4d0d62eae46fdd91017f3690f13dd7f969a5c751a82"
    sha256 cellar: :any_skip_relocation, monterey:       "a75bb6b28af92edcb689eca2cc53b14a39c64be6a659e0e0151133d28a43bb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff224f6ee61a3490e24cd0791071ab3e870766895de563eefaf5fd87faec487d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end