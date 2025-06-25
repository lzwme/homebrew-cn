class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.1.tgz"
  sha256 "49c7ccd8ff9d348eb9e7f975b8f7db67f1be74a870aa838e6bf24859d3cf0d83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f00be657c2e7b6adfc675d12cdc89f2232694762104c39756383f98cfdbb61e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f00be657c2e7b6adfc675d12cdc89f2232694762104c39756383f98cfdbb61e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f00be657c2e7b6adfc675d12cdc89f2232694762104c39756383f98cfdbb61e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f341557fbc2dca2955e841e764748b0ce6ceac0b3ce5bfc7423bfa47914a312"
    sha256 cellar: :any_skip_relocation, ventura:       "7f341557fbc2dca2955e841e764748b0ce6ceac0b3ce5bfc7423bfa47914a312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0562539b344e50945d33be3def61dc0fb4b8d166b51b748c124d7949f5d0f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8668a0bd90a26e556af85b7bb592eb7fdbb00312b19fcc7f5d21b8daf88f5ef"
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