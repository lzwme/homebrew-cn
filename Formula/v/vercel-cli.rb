class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.5.0.tgz"
  sha256 "fbe3043a8065854292d0f70d7090bc1072e17f6e33ca64577e6ffbe81e593647"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f67236e4132786df24c99b368235fa2c4280b56f33a493522c15c66fe93adc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f67236e4132786df24c99b368235fa2c4280b56f33a493522c15c66fe93adc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f67236e4132786df24c99b368235fa2c4280b56f33a493522c15c66fe93adc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e675291d3917d0937a51c62434fa74a1b9c63542613beefea8d388e1691a95f3"
    sha256 cellar: :any_skip_relocation, ventura:       "e675291d3917d0937a51c62434fa74a1b9c63542613beefea8d388e1691a95f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a055934ce6537c52defef3324f4b4e418c6b9e0c855a02a7fe3818458a1b9ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef0be97001d34470042a7a226da7b52706dc267db085e84f6cebd02c9f53650"
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