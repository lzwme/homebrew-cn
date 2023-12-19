require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.0.0.tgz"
  sha256 "50e7a5eefcff3cebae12f65d1baffecb1d818cf460934653ad6bdeeff2e53d34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac982dfa31b3986302eb7e530a97c3378ffc97ab3cf6a8a8d93a1177f617f191"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac982dfa31b3986302eb7e530a97c3378ffc97ab3cf6a8a8d93a1177f617f191"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac982dfa31b3986302eb7e530a97c3378ffc97ab3cf6a8a8d93a1177f617f191"
    sha256 cellar: :any_skip_relocation, sonoma:         "89b985c39029990f14b7a28281ddb446e33a9f4703407e891201848fe0f51b0b"
    sha256 cellar: :any_skip_relocation, ventura:        "89b985c39029990f14b7a28281ddb446e33a9f4703407e891201848fe0f51b0b"
    sha256 cellar: :any_skip_relocation, monterey:       "89b985c39029990f14b7a28281ddb446e33a9f4703407e891201848fe0f51b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4b151aa94281a1928b82aa3ad0253963d19ba2c81f49c44248e28e38d386d6"
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