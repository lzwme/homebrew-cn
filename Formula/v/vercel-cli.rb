require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.9.tgz"
  sha256 "c4a501dca81222e352f0919f93beffaec9703b4a98a03ece23d758f0c3abbfbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24a75a23384fe0de623c43fc791e605f5e421e64f6b1f05008864b94b99cc6f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24a75a23384fe0de623c43fc791e605f5e421e64f6b1f05008864b94b99cc6f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24a75a23384fe0de623c43fc791e605f5e421e64f6b1f05008864b94b99cc6f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fb68eef102d56b68cb9f9be702be71896151dad081c1da546e14d2ef37820a9"
    sha256 cellar: :any_skip_relocation, ventura:        "2fb68eef102d56b68cb9f9be702be71896151dad081c1da546e14d2ef37820a9"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb68eef102d56b68cb9f9be702be71896151dad081c1da546e14d2ef37820a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c3c72fea13c70dd7fe43b8afe07c409f5f64dc0d26c30fe7c0d2f64de3d7b3"
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
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end