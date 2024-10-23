class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.12.1.tgz"
  sha256 "181e40b22aa9e3e140741028a4fd38751f879513d088eb0e273326e10389ccb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f550e139c1e96cd1f54bc8a5e298d84ef3320c7b8f8169b64ce39749087451c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f550e139c1e96cd1f54bc8a5e298d84ef3320c7b8f8169b64ce39749087451c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f550e139c1e96cd1f54bc8a5e298d84ef3320c7b8f8169b64ce39749087451c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "168476b2e67f23262089e599376db9ea942b61f0672b9d332a50b1669e7f67b1"
    sha256 cellar: :any_skip_relocation, ventura:       "168476b2e67f23262089e599376db9ea942b61f0672b9d332a50b1669e7f67b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9304a7119a398e7efbd92990f00e7d2cc53ebb95322eb53a48581c0dbf2c0f0e"
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