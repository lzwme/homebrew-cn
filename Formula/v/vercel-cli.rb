class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-45.0.8.tgz"
  sha256 "02ccc6fb5793a7e21e26e5cca0f6083f020f73d8a03f901bb4eb39ecd6e2afc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170084dd45db529d0e9a7815779219848205570b32e1059d70c8d202b4d475b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170084dd45db529d0e9a7815779219848205570b32e1059d70c8d202b4d475b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "170084dd45db529d0e9a7815779219848205570b32e1059d70c8d202b4d475b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b16bdb07c25d4f9a7b8f0c3791c448091136c9c7f54ea768d17251c163dff3c3"
    sha256 cellar: :any_skip_relocation, ventura:       "b16bdb07c25d4f9a7b8f0c3791c448091136c9c7f54ea768d17251c163dff3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7abee3d93ef4f5f79856834ee31364411c8fec008f26a887a38c1eb732ce6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f21220304291a97aadd4ce993e17f582fae44f29754999bbd5ae33c63930820"
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