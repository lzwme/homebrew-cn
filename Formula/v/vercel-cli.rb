require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.5.2.tgz"
  sha256 "d803f13059a33b12b3d4ba022b196abddb3a3fce5c4758f6388503eee094f34d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32767ae3c8339aea1b1a6753cc1c8376b67e83a36a814f4a09d3d8693c25b982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32767ae3c8339aea1b1a6753cc1c8376b67e83a36a814f4a09d3d8693c25b982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32767ae3c8339aea1b1a6753cc1c8376b67e83a36a814f4a09d3d8693c25b982"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ffab94085f76630b712d1360c6300875a4013c5f8e90b1cd45bf257bb98a5fd"
    sha256 cellar: :any_skip_relocation, ventura:        "1ffab94085f76630b712d1360c6300875a4013c5f8e90b1cd45bf257bb98a5fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffab94085f76630b712d1360c6300875a4013c5f8e90b1cd45bf257bb98a5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a283a26c27f25a13139395d17379f728c43785629f87cc31c385c24a67619a84"
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