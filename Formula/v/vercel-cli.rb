class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.2.5.tgz"
  sha256 "77d482fd0832915ec00b25628d004c58bcc8fe8d03397251a43e1dccc9b40984"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aae6fcadb0519130d9011933e6f4afba3a875b9c264a9996ff2778787d21387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aae6fcadb0519130d9011933e6f4afba3a875b9c264a9996ff2778787d21387"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4aae6fcadb0519130d9011933e6f4afba3a875b9c264a9996ff2778787d21387"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0e0be740cdcc8827eabe2291024bd6cffcc72514a16254f1c83c7e3353566f5"
    sha256 cellar: :any_skip_relocation, ventura:       "f0e0be740cdcc8827eabe2291024bd6cffcc72514a16254f1c83c7e3353566f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3588c2e4bfe789ba3994c3587d16e877cd18b432bb7cb6a03bb27578ed2ed28a"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end