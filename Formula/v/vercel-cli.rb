class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.5.4.tgz"
  sha256 "5b714862334c9723c7a260e117c39165bf65ecc1f09024015356c71d099a5b15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db85e2efd4557744d5becb75fe6e724be2175888d29aad8955a674449a3bbebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db85e2efd4557744d5becb75fe6e724be2175888d29aad8955a674449a3bbebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db85e2efd4557744d5becb75fe6e724be2175888d29aad8955a674449a3bbebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "933c079fffbab51176991cd761cd30195af5c3606a83a67537d442572ed6fc82"
    sha256 cellar: :any_skip_relocation, ventura:       "933c079fffbab51176991cd761cd30195af5c3606a83a67537d442572ed6fc82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "318ce1972ed5676ccaed91b15fac401011608cb7f258df085c45bca168910c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514c4ffc18c8febc1e8639338f4de9d48008d4ecc6256f19b644f96466193641"
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