require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-35.0.0.tgz"
  sha256 "61600b21749196c3310fd355336d4776e43c161bf84248c3fcccdcd6804887c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3886fea7fa0960f3c641768a656ca8ffc866ac89fb225eac5ddbfbd460220190"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3886fea7fa0960f3c641768a656ca8ffc866ac89fb225eac5ddbfbd460220190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3886fea7fa0960f3c641768a656ca8ffc866ac89fb225eac5ddbfbd460220190"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bd2720a2d30168859e85e2e0877e06330743ff04fae68be6743626aadc44aa6"
    sha256 cellar: :any_skip_relocation, ventura:        "9bd2720a2d30168859e85e2e0877e06330743ff04fae68be6743626aadc44aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "59f97101f7562c99a633e8199dd9680ed452ad89949ae18b72815ee1b8c1ab8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2392eeec3415748d40054ac89add511ba15e17b3fc83fee3d784c8406b3a900"
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