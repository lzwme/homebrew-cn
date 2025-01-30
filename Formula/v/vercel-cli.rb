class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.4.2.tgz"
  sha256 "1bef36667f5d309aef3b828a0f9b01ef98b4d9108c86c2954f658d76c59a70bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbeca1e3c59565c17b4ebd77d9f6fac0e881026441d22258215fae6c64dfb3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbeca1e3c59565c17b4ebd77d9f6fac0e881026441d22258215fae6c64dfb3ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbeca1e3c59565c17b4ebd77d9f6fac0e881026441d22258215fae6c64dfb3ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d66eb146504512fc0598e6396d30f25ca08d974b6c1825c0b7a5d88764d500c"
    sha256 cellar: :any_skip_relocation, ventura:       "6d66eb146504512fc0598e6396d30f25ca08d974b6c1825c0b7a5d88764d500c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8c315aac44dba2410ff56d3d5628b0224d0f07d12d6cc93b47277d8a4ad4bc"
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