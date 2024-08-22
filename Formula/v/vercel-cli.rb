class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.0.0.tgz"
  sha256 "dacfa7739bf58a64cabaf7a9fb3e2892388717ab1861d270a79a51b210449ebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54fc50ec4ff001aeb02997625591fd4c8650fb8dcfb05ac459491c99a51a4929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54fc50ec4ff001aeb02997625591fd4c8650fb8dcfb05ac459491c99a51a4929"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54fc50ec4ff001aeb02997625591fd4c8650fb8dcfb05ac459491c99a51a4929"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3cc4d8d339e3728b261d612e393af8f53e44e1e65869416e358ac5dcda6a8d8"
    sha256 cellar: :any_skip_relocation, ventura:        "d3cc4d8d339e3728b261d612e393af8f53e44e1e65869416e358ac5dcda6a8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d3cc4d8d339e3728b261d612e393af8f53e44e1e65869416e358ac5dcda6a8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6acbeb2774d01bd33dddbcf3aa1d068edf35e1bd922838f3ecd053e608ec161a"
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