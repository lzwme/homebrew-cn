class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.1.0.tgz"
  sha256 "6b1edafa3f87f6a86fbec381c06257503c0644b9678918d46011c607cd9c25b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d12c549fd286d290c7470aaddc5654f69020ca4a780b57679f36ff6f259189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d12c549fd286d290c7470aaddc5654f69020ca4a780b57679f36ff6f259189"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93d12c549fd286d290c7470aaddc5654f69020ca4a780b57679f36ff6f259189"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88bee40cbd68f9562d4a1ab266dbffa01e8a0e0de4dd299870c10b8ac1c5894"
    sha256 cellar: :any_skip_relocation, ventura:       "a88bee40cbd68f9562d4a1ab266dbffa01e8a0e0de4dd299870c10b8ac1c5894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10293242402975a9ea5536cc4d957fa3795cddfe3aa2b4f41df99535bba1839d"
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