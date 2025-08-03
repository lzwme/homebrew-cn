class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.7.0.tgz"
  sha256 "1629ba2333d9d7058694085cd09f49ffcfa6ebc5884c81af718eda958e86e8ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fecac100365864b2fb23fb170aded81126ee2c75e2aa89a4e7b7bfd0946b6f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fecac100365864b2fb23fb170aded81126ee2c75e2aa89a4e7b7bfd0946b6f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fecac100365864b2fb23fb170aded81126ee2c75e2aa89a4e7b7bfd0946b6f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cfcc247efa7fd29c9b838b4c007e27ed14fb5a88b4a2d4a6a99ee5b80bb5c19"
    sha256 cellar: :any_skip_relocation, ventura:       "7cfcc247efa7fd29c9b838b4c007e27ed14fb5a88b4a2d4a6a99ee5b80bb5c19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5646f257f54cb2cb96a7617d4734cefaa6cfb5a2dd8c76c92b89626d3dbc516a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a40c5ad4b18290fb603fbe33ffc86a53feda3155c8e6b61192b9fa945b8f81"
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