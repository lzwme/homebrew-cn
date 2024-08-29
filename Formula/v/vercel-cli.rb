class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.2.1.tgz"
  sha256 "8677054064173385009708b24d306f74ff5f01871893392ad79a9b42515a95c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd79bf6b656813d59fd7482c6bb975e3f63f1e90e2654fbf1418d38e584071e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd79bf6b656813d59fd7482c6bb975e3f63f1e90e2654fbf1418d38e584071e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd79bf6b656813d59fd7482c6bb975e3f63f1e90e2654fbf1418d38e584071e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "339a815b2ea52c27ed1284ded802734785e09e8408186d58e4e8a62609423528"
    sha256 cellar: :any_skip_relocation, ventura:        "339a815b2ea52c27ed1284ded802734785e09e8408186d58e4e8a62609423528"
    sha256 cellar: :any_skip_relocation, monterey:       "339a815b2ea52c27ed1284ded802734785e09e8408186d58e4e8a62609423528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4a8e4001636e33513f3e59628ae84e0993182638dca280ff0016a0890859da"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end