class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.9.tgz"
  sha256 "0090d079f7039be327598a6d8de403ff0456254a79b410ed85f5c2dbbf5c454e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8e5342c5700d6e42a9912a6691e68558a30cd41032b50905169b1620edc59bd"
    sha256 cellar: :any,                 arm64_sequoia: "ae360ca22e6dccab9265f154c88e3d355753309bea4b48a6d63389b299db91d8"
    sha256 cellar: :any,                 arm64_sonoma:  "ae360ca22e6dccab9265f154c88e3d355753309bea4b48a6d63389b299db91d8"
    sha256 cellar: :any,                 sonoma:        "c8b9a936115950309d8bd5c95889fc8c13bbfa08869002e5ad49e413c8c23417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be9e6b234011f72155a03692ce3d6db6685e4fb739360df08c54bd259215f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffeeda8ed4cd80086b89b8bbb35d2dff7ef45927c62a1e9675bbc679636cabf0"
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