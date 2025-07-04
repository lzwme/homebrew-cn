class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.11.tgz"
  sha256 "9e2724d2e843589fbfdcd476639e6a19927a7d31fb8f9ab4b164134f4544d045"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7522e6e7af6176b1324f01fe5e6236701b7a568462415dfe1c8b9446255815e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7522e6e7af6176b1324f01fe5e6236701b7a568462415dfe1c8b9446255815e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7522e6e7af6176b1324f01fe5e6236701b7a568462415dfe1c8b9446255815e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "33dbedd45d5b3a6c028df7f5a0d5eb9ca3a5b079069fa18ad108f93e5d59fcca"
    sha256 cellar: :any_skip_relocation, ventura:       "33dbedd45d5b3a6c028df7f5a0d5eb9ca3a5b079069fa18ad108f93e5d59fcca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "547b1d72222ec230fe3caa603547647d817e6a6000e4e1fd97a3ede43f31ff65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b4199fa428759e67ffae6b6a6fc06098f1732b973fe4459dfc614423894fbb"
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