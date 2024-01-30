require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.4.0.tgz"
  sha256 "826252f6cfe5ab7d23b82deca3570e49386fc9ac6a7b1cf6b9121b725a47b0ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b93a0f7822ad089f3d090e5df15d426a60cd3783c66973183c849b0b2b44954a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b93a0f7822ad089f3d090e5df15d426a60cd3783c66973183c849b0b2b44954a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93a0f7822ad089f3d090e5df15d426a60cd3783c66973183c849b0b2b44954a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a5ecf4769e8833bac4d6878c3746ffd9edb44c08c7e875858ab9e451499e528"
    sha256 cellar: :any_skip_relocation, ventura:        "8a5ecf4769e8833bac4d6878c3746ffd9edb44c08c7e875858ab9e451499e528"
    sha256 cellar: :any_skip_relocation, monterey:       "8a5ecf4769e8833bac4d6878c3746ffd9edb44c08c7e875858ab9e451499e528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a08b58a7328730d08aa3e7b07120b04127d8661fff16f9bd32a73db1e5224a"
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