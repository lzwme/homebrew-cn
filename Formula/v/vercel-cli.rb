class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.1.0.tgz"
  sha256 "b9d3fb60bf9f1675ce706a0f8a79162c8ca0bbb09d9d1c512a52518c06b23c0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77313a3141648084f2781734052f278ca63f4d26b69e82a10e0325d363b0b703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77313a3141648084f2781734052f278ca63f4d26b69e82a10e0325d363b0b703"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77313a3141648084f2781734052f278ca63f4d26b69e82a10e0325d363b0b703"
    sha256 cellar: :any_skip_relocation, sonoma:        "933b72b738a52433805914146e9a3065a7195c4693a4ff8daa2d44782051c74d"
    sha256 cellar: :any_skip_relocation, ventura:       "933b72b738a52433805914146e9a3065a7195c4693a4ff8daa2d44782051c74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d43e6a5d24f88f7f504a6f9e50b11aee15de9243b123598aab404cf28318962"
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