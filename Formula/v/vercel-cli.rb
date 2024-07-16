require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.4.0.tgz"
  sha256 "d70fd5689a5f32bb597c25e09fdfce168841eebbf1ea3adaf7f9319a558a3f56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d525545416fb8bdf87ca550f0926db8a1b311f3a9d5e33195040727da88745ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d525545416fb8bdf87ca550f0926db8a1b311f3a9d5e33195040727da88745ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d525545416fb8bdf87ca550f0926db8a1b311f3a9d5e33195040727da88745ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "488b3507db1a003a52aa95111f8b18f2362cd481d42d95919f5ee05898ee1022"
    sha256 cellar: :any_skip_relocation, ventura:        "488b3507db1a003a52aa95111f8b18f2362cd481d42d95919f5ee05898ee1022"
    sha256 cellar: :any_skip_relocation, monterey:       "5b13c5bc803e703df8f9bbf4c5e2b0584427a0ac17ee3fa78e8f984f25253dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc736ea33ec3832256d4f964568261d99cd13045fb391aa74edb456ca3e8910"
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