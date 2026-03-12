class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.6.1.tgz"
  sha256 "74bf3ee5ca636c504d19e6a9a94f8bfd9d600d3f680bdbec3acf42bf2b3e1626"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45a627c675138cc8bc9747c81a37822af267ba9ddc7120f09376b0820091db55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e60213efa9e25e70067c16c477714dc688d494773fde5e67297afa34d951ec3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e60213efa9e25e70067c16c477714dc688d494773fde5e67297afa34d951ec3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fd1e6fa307894b62e24ffd02715da4925ecfe534dfe36e87bb5c314c08b9d7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236531a94a4f522e2ceba64b695d440e4ee133abe0231ad6b81a5ca07e231ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236531a94a4f522e2ceba64b695d440e4ee133abe0231ad6b81a5ca07e231ab5"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end