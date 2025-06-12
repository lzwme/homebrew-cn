class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-43.0.0.tgz"
  sha256 "953856c199a5aa29cac507436f0155a7d2ad069a92e846cac7cf49815815d45e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3179a33549939bbbe34be8900c918774417ce1a5345f787e3f2a992fdac3fd9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3179a33549939bbbe34be8900c918774417ce1a5345f787e3f2a992fdac3fd9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3179a33549939bbbe34be8900c918774417ce1a5345f787e3f2a992fdac3fd9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1529c5c6a2d1c4327f634d5f6eadebbb60a9ff9b1f3261109bcf95083aafc9cc"
    sha256 cellar: :any_skip_relocation, ventura:       "1529c5c6a2d1c4327f634d5f6eadebbb60a9ff9b1f3261109bcf95083aafc9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e09ef469ba5b901246b33ea0a7a181837868ef8b46f036e3da9d5f850d6c19d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fda4971592731b1feb3cfe77f4b281442f9393d0e3dcbc9c7cb1b2fba3a673"
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