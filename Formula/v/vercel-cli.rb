class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.7.6.tgz"
  sha256 "af88191ce8ffc4910525913ce9a6d285c596cdd97f114caa6ac2d36beda8c947"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73c2fb67b1924158c41368d83b6f0295952b7d3fad50d18685551793e6bc2e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73c2fb67b1924158c41368d83b6f0295952b7d3fad50d18685551793e6bc2e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c73c2fb67b1924158c41368d83b6f0295952b7d3fad50d18685551793e6bc2e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfeca53145c53fc09c460b17421f392ca54ee81b139f15d4524bd57b2fd7fd30"
    sha256 cellar: :any_skip_relocation, ventura:       "cfeca53145c53fc09c460b17421f392ca54ee81b139f15d4524bd57b2fd7fd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dadaec9734d2aaf9058283032512a1c29f34e404387d1d9d00a439dd0d804a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed69cb8cea57a5c9cb7075b4a3f71e2e44350d80f918c0a27193eba45288c4bb"
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
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end