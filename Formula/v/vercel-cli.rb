require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.2.8.tgz"
  sha256 "9d6e547a74d0f87e74e25a087e425edef11e205aa3f67293cff1db75ede845a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca368a0fe7f8a8e3f748ab23204a25fb75e40da342b267abb5d6c2cfaca4a70c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca368a0fe7f8a8e3f748ab23204a25fb75e40da342b267abb5d6c2cfaca4a70c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca368a0fe7f8a8e3f748ab23204a25fb75e40da342b267abb5d6c2cfaca4a70c"
    sha256 cellar: :any_skip_relocation, sonoma:         "63e4710736e091e71b0466c5757623fede78f56ceddf8ea51713cf65c755103a"
    sha256 cellar: :any_skip_relocation, ventura:        "63e4710736e091e71b0466c5757623fede78f56ceddf8ea51713cf65c755103a"
    sha256 cellar: :any_skip_relocation, monterey:       "63e4710736e091e71b0466c5757623fede78f56ceddf8ea51713cf65c755103a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2755a4a3905d8738e59b0cbf4b1c4398505280083e8c113fcaceff79e41353c"
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