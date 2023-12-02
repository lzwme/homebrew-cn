require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.6.1.tgz"
  sha256 "4318cbc70e55f4dc7cf7a5efd0d5c3bdc966173278a6ac5e307e8d375d48d7e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a4c146bdbc7fc9277e05e25796a6250537cd6163bf903359a39f154ea73e10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a4c146bdbc7fc9277e05e25796a6250537cd6163bf903359a39f154ea73e10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4c146bdbc7fc9277e05e25796a6250537cd6163bf903359a39f154ea73e10d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4206a7e528e0c0b8be307c2bc996740626f56bc8995a53d505e2c1b7e4919e3"
    sha256 cellar: :any_skip_relocation, ventura:        "a4206a7e528e0c0b8be307c2bc996740626f56bc8995a53d505e2c1b7e4919e3"
    sha256 cellar: :any_skip_relocation, monterey:       "a4206a7e528e0c0b8be307c2bc996740626f56bc8995a53d505e2c1b7e4919e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d599e18e296c4497a95f5fee7268fcee9fa7173dba63222dceff7f23cfef26"
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