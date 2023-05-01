require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.0.3.tgz"
  sha256 "944aa9bba09897faacd975c181d6c2a2f36982a4cd22a76a063d8d4bb8383a9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f692c2913675a518349d6ae9e83df4db58ec65751479852c3693e92ec3247b98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a866bf82c49b6fab4db4ba4c1c158bed730629c930826343c1b00ea571b877cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2db3be9a9f6e287c51396e310ed36b24590dac8653c15cdd8bf9b1ce4662cde5"
    sha256 cellar: :any_skip_relocation, ventura:        "cacd110f8c3c17a1a41867facbd857ef9e836b2be0ca5bd99bf1f73b39514570"
    sha256 cellar: :any_skip_relocation, monterey:       "80c32280d338571b81fdd727953ef0f2e5b4057171d5f5f3b09d02fbcf416484"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fd753e8690501f7b929a10605d87b6bd5e39979d27a1792590e7cde597436c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d02d158780f063f579dead78292d42eedcf7613bf27bbd675e4f7cd7c66818d"
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