require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.3.0.tgz"
  sha256 "dd55003281809fbb82d3c7596f239bad31e8e15072dee7f3b48bea1fbc6aa117"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3981f426b343f13f2657fa9f0a5f081afffbf96cc81ba17487229340205013a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16f49ce79da017426e824459db13eb53c76d639e907be34d0e63e49d2173c65e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d9c49e9d6312c667fde1f43b711f71a50352b953df4c0cd365392688e32aab3"
    sha256 cellar: :any_skip_relocation, ventura:        "9e22804dd5ad5679765a23e98aa8b20a8ecffaba2d8414c5f985f073307b89d6"
    sha256 cellar: :any_skip_relocation, monterey:       "365714ad0c2cac4ed4acdf4ebd2b14326fcae0a0e98c17cb408aa7ba1e7ee6d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6f1abb47811884c221aab041eff848e4d1820c1455c426bea6eaf449dc6958d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "117e251e4e4a3b71b0ca59c8a96306f4a5cea801335bbc91bf0da3012798fd5b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end