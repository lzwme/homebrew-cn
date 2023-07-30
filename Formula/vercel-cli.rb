require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.2.0.tgz"
  sha256 "457281fa55df2c80936f9279c19544f791fdb37dd8eeb6aca436c8615249f2fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7476078ff81ffa667ebb66033d91c2e3455404ad1d5e5e323aad75e7464c53b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7476078ff81ffa667ebb66033d91c2e3455404ad1d5e5e323aad75e7464c53b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7476078ff81ffa667ebb66033d91c2e3455404ad1d5e5e323aad75e7464c53b3"
    sha256 cellar: :any_skip_relocation, ventura:        "f7eee75fcbe038609569c93e92eb4a2bc970043304bd71c81ad4b9d974c4cfba"
    sha256 cellar: :any_skip_relocation, monterey:       "f7eee75fcbe038609569c93e92eb4a2bc970043304bd71c81ad4b9d974c4cfba"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7eee75fcbe038609569c93e92eb4a2bc970043304bd71c81ad4b9d974c4cfba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd852c3d92052bdeb440f22af5eac8c01a2d13817e43e4caf040cbfd04615aa"
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