class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.0.0.tgz"
  sha256 "852c74c93c385c1240136dc8d644da5279677c2b2efe4703ba9760f96beab75b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694acd285ca3c8276558d5bb7a0dea7bddb451f0cc9925a829f2f5aa8f55f419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "694acd285ca3c8276558d5bb7a0dea7bddb451f0cc9925a829f2f5aa8f55f419"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "694acd285ca3c8276558d5bb7a0dea7bddb451f0cc9925a829f2f5aa8f55f419"
    sha256 cellar: :any_skip_relocation, sonoma:        "27af74617e2c6e6945680ef76903be91b8c334b66068ab7bc1f4000485de02a8"
    sha256 cellar: :any_skip_relocation, ventura:       "27af74617e2c6e6945680ef76903be91b8c334b66068ab7bc1f4000485de02a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0bba389f196f9b780ef0be8466590803476970f42772c2e81d372e097641f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f811bc94cb2d64f1fed265dcee2c2ca0aba427473899695b9632e06f5fc5f93d"
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