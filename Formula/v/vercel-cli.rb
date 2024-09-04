class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.3.0.tgz"
  sha256 "454cf5dd8dea9c7757dd9a36d448fc4ff930a46adf956a8c8955acb10d9c3805"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1561843fab1d3b91af5ccca2beb54e21b06d389df959560b495afe6b6f49ca57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1561843fab1d3b91af5ccca2beb54e21b06d389df959560b495afe6b6f49ca57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1561843fab1d3b91af5ccca2beb54e21b06d389df959560b495afe6b6f49ca57"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4e31325ea6283826cd41bc682acf83184bd814d0fb73bda7dec81c91cfde9a9"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e31325ea6283826cd41bc682acf83184bd814d0fb73bda7dec81c91cfde9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e31325ea6283826cd41bc682acf83184bd814d0fb73bda7dec81c91cfde9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86ea3538b9340c54f464877f59fad8a1eabca6f43c5023bda140d0b2497d94b"
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