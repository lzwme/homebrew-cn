class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.4.0.tgz"
  sha256 "434225b97d238385bb63f934e0047d3ee87d0649619653a4134226b5155ebdf5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d457d527a38d762a43ac3e635ab4e2e87be56cef7fade49ca1fa58aebd49e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d457d527a38d762a43ac3e635ab4e2e87be56cef7fade49ca1fa58aebd49e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d457d527a38d762a43ac3e635ab4e2e87be56cef7fade49ca1fa58aebd49e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc86c459a9ebaa1bd23b659661711b41c990f7637989267db25772e5f1010378"
    sha256 cellar: :any_skip_relocation, ventura:       "fc86c459a9ebaa1bd23b659661711b41c990f7637989267db25772e5f1010378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033058a46cd72b8f8400eba410c55f10bfbc9ab85288cfc2bba0e9baa52683fb"
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