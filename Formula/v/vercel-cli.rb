class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.3.0.tgz"
  sha256 "2eb0231ae635f585f935cb80d4c1a59bf379510e734ec51bf18e3e8d5c0180af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d283ebd0aeb32bd24f6daa5d80d42f321fda76f643ed01a2142fc3a6941907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d283ebd0aeb32bd24f6daa5d80d42f321fda76f643ed01a2142fc3a6941907"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62d283ebd0aeb32bd24f6daa5d80d42f321fda76f643ed01a2142fc3a6941907"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c0c5f9c07cd138695d7954d39ddcd9eb85316c6cdcb77363d83dfa7fd5bec54"
    sha256 cellar: :any_skip_relocation, ventura:       "1c0c5f9c07cd138695d7954d39ddcd9eb85316c6cdcb77363d83dfa7fd5bec54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50d35a067a238a293547c683e76fb47c98130a38bf1fa155d376728c8ffea40"
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