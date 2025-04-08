class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.5.0.tgz"
  sha256 "c9e66ab3b72b64edd005b624c50b244739dd07bbcb9aea4953f90b4b5ddef4a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42115b41b74b38807b7082a3805ecbf42d16c81c0dbcf15475837779c69a0b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42115b41b74b38807b7082a3805ecbf42d16c81c0dbcf15475837779c69a0b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42115b41b74b38807b7082a3805ecbf42d16c81c0dbcf15475837779c69a0b9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9f8fa316e3e59756b88a197168862caaea9c7d93f0f256727da92bfe0859aa"
    sha256 cellar: :any_skip_relocation, ventura:       "7a9f8fa316e3e59756b88a197168862caaea9c7d93f0f256727da92bfe0859aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180b8bf8abc66148fa65a1b85feb8a5750ffb1f9cc5149817b34551074cc3b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3203b18e0a346c9dd4344ee8ef43e91ffc1cf8c42ae5c5c717c2f7a0259c0076"
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