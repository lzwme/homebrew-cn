require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.2.0.tgz"
  sha256 "09d46f111598c93f21624063fe9696cf221c2e9a723fede50259e36defb87ebd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a75c5210a2403ed822498af5977baed9ee7c0f714cbc47662c01dd2a889d346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a75c5210a2403ed822498af5977baed9ee7c0f714cbc47662c01dd2a889d346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a75c5210a2403ed822498af5977baed9ee7c0f714cbc47662c01dd2a889d346"
    sha256 cellar: :any_skip_relocation, sonoma:         "89924df9cea9c78622c6b5a99f82c5eeab261f0cdd11d9574f17e06718c9f0c2"
    sha256 cellar: :any_skip_relocation, ventura:        "89924df9cea9c78622c6b5a99f82c5eeab261f0cdd11d9574f17e06718c9f0c2"
    sha256 cellar: :any_skip_relocation, monterey:       "89924df9cea9c78622c6b5a99f82c5eeab261f0cdd11d9574f17e06718c9f0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6dd619018d9de0d104ab62b2e28dd0ca7960f2aec4d46dc3d3399358be9c78"
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

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end