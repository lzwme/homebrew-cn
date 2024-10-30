class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.13.0.tgz"
  sha256 "3f701c0c72a5733470070252dc6b3368bdc0ece42bbee89ff1a590fbd29a9180"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d98dd09be29dc6bc89a381ceec4ce1ca9b790eb6e4b2bec0415730d45e376749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d98dd09be29dc6bc89a381ceec4ce1ca9b790eb6e4b2bec0415730d45e376749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d98dd09be29dc6bc89a381ceec4ce1ca9b790eb6e4b2bec0415730d45e376749"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ccb06268b3508a3e5dc87761e630333d42ab8537c43b2648f342ca93c63ce0b"
    sha256 cellar: :any_skip_relocation, ventura:       "7ccb06268b3508a3e5dc87761e630333d42ab8537c43b2648f342ca93c63ce0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bace41df19b754e72d845cb6750e2aa7535becd1ddb90d887d8220b1b850add"
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