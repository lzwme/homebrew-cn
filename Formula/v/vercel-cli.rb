class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.5.3.tgz"
  sha256 "a8ae05e7671e54839f86d441878f84690708f08147e7f366359159fc040aa76d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c78d0b00b15c30c9dd9279d2958ea237696ccd116ea00000f313f7db400551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c78d0b00b15c30c9dd9279d2958ea237696ccd116ea00000f313f7db400551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06c78d0b00b15c30c9dd9279d2958ea237696ccd116ea00000f313f7db400551"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58142b3ad569a6c2b4eff124f6073e73edf94dcc0826941f4580a9f73cabd44"
    sha256 cellar: :any_skip_relocation, ventura:       "f58142b3ad569a6c2b4eff124f6073e73edf94dcc0826941f4580a9f73cabd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e888028b3ca9e537729142c61b8a5f8f261a0870d55f97cc3c21bf2d0171cd7a"
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