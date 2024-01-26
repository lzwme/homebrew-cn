require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.3.0.tgz"
  sha256 "a6d72347353b280334fc5e9d9b385bc10daf2270bdc9cbebf47fca67cd95463d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e9c7f5b0ebb6fcde547cbb94834a37f78560beee4c12e8d880e53bb799e3e71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e9c7f5b0ebb6fcde547cbb94834a37f78560beee4c12e8d880e53bb799e3e71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e9c7f5b0ebb6fcde547cbb94834a37f78560beee4c12e8d880e53bb799e3e71"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a36f8bf579fed6c3b7e6a1b4f388a5f54007e01fdb5c08705601136afa9cd9b"
    sha256 cellar: :any_skip_relocation, ventura:        "4a36f8bf579fed6c3b7e6a1b4f388a5f54007e01fdb5c08705601136afa9cd9b"
    sha256 cellar: :any_skip_relocation, monterey:       "4a36f8bf579fed6c3b7e6a1b4f388a5f54007e01fdb5c08705601136afa9cd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760de1bcece865eb627a3c0f4bdf54774885073ac65dc5f81d050f3777449d13"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end