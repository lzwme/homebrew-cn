require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.11.tgz"
  sha256 "ef152500e7f90b76203ad93bb8126256df645724119a9ae31d84ca2c5252c5fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90e2a8b053db91b0a75b02721a6f6539f7166fddac197a693c700757d95d39b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5718a6d88e4ac0551e5714a7b9d894c5b3427c8188703989de9b797d3a7d76bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b6f38b0ed9a3fbf7b48bfea3c57b6e8d544be509acac668bd648e0c4ad8f020"
    sha256 cellar: :any_skip_relocation, sonoma:         "6673c6ff47431bf583f0fc9169047eaf3965b025661a66cb26126e2b7527866a"
    sha256 cellar: :any_skip_relocation, ventura:        "f1ee4ef12785dbe65b62b008951b4c88cc3e5e600a53e15da1953b0be908ee77"
    sha256 cellar: :any_skip_relocation, monterey:       "2c9b00000297c7d7ca28cb9ae8aba1c8de9bdfae85068e33c84ca76a09133921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a95459c3579cf0fc07263e361ea37eff195219b5a1b98e65395156738102f4"
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