class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.11.tgz"
  sha256 "711146194223a31bf37f467ee7c81a1d105ed9e82d120d4ac04b7509673f1bfe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d46b0cc659164c32e75e4be2bf1ca5dbc86be24541879f392b48ee2e639d95c"
    sha256 cellar: :any,                 arm64_sequoia: "6a3030d1a4df69f73ea2c6bed10f7324ad737c3814444d83293ac63d60af5dcc"
    sha256 cellar: :any,                 arm64_sonoma:  "6a3030d1a4df69f73ea2c6bed10f7324ad737c3814444d83293ac63d60af5dcc"
    sha256 cellar: :any,                 sonoma:        "b35f67fed2cfc31401114b989b5b49bdf29dfe4fc06e9f9cdac5487799af96ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1216d580887ba78d3d0970643d3ce73f9dacc5fa2dfaa7ac169e4a42ebff72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4de564b0cfeccb56964477f7850c74fe49669e4c8412ba5833764ea09120193"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end