class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.2.1.tgz"
  sha256 "a28ddb1eacbe1b44cd047804903a86a623bd0116b78ece141da17048839d0e60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f1493e358dd59e2d28f17ca9d4a6a4a135359460dc1443a395fc29f1ddb5ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f1493e358dd59e2d28f17ca9d4a6a4a135359460dc1443a395fc29f1ddb5ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0f1493e358dd59e2d28f17ca9d4a6a4a135359460dc1443a395fc29f1ddb5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c0bdcc9cfda38ff68f41dbd16f472dcb84ebfc42afa97d4a964b855629f8d94"
    sha256 cellar: :any_skip_relocation, ventura:       "0c0bdcc9cfda38ff68f41dbd16f472dcb84ebfc42afa97d4a964b855629f8d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb4ed3156d7b139f5827ed5eb662ae0e3d61c0b3b172987b1ae0826f3773b310"
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