class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.9.0.tgz"
  sha256 "5cb6be3ad99e14e33129c80812bcf57bf8430b006fbc1088d468c3aedfa25b21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b03d6bbcdc1192c1dac6d017033a250ddbd186d4080163ef8f7d88c636429dc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b03d6bbcdc1192c1dac6d017033a250ddbd186d4080163ef8f7d88c636429dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b03d6bbcdc1192c1dac6d017033a250ddbd186d4080163ef8f7d88c636429dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe599c77668b04f2e4bf3268a94951f6226635bc7e2f96172969de300b95e0c"
    sha256 cellar: :any_skip_relocation, ventura:       "dfe599c77668b04f2e4bf3268a94951f6226635bc7e2f96172969de300b95e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699eeb1b27f3e59f8e63fcce48a0b40927fd6d15936d46fc18c66a03361e6ea0"
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