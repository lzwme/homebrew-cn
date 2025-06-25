class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.1.6.tgz"
  sha256 "f641bc41394e03455d539603f0b095838df3ef0f2189bd7de192378aba7020b0"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "35c93b9a85217fe76b582ec1acc62fdf210708dae9a1aeee57585f2f6b1c4ff1"
    sha256                               arm64_sonoma:  "da0ead36b0fa1bc4371d3180ca9297d696c128d36a8c450cd480a623f96dae2f"
    sha256                               arm64_ventura: "05902cf1a2b1290bef8ac3f3bc7b9ae9e4916785c7e8bc281a25231f5ecf4eb3"
    sha256                               sonoma:        "d7f2dd8a37429a7e733f4e562eedb8ae6456f4d7fa848e379159d60d3ecd863f"
    sha256                               ventura:       "3baa6367d23df19d4fcdc89608d3abfbdcd1959f0d995f5a5cb79bdd95cdea97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7725369d5250095e9c66a9dafce84ba9b3c41f5e70e79204ab9a50eb21da693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2400d5ca2f1e81b58eb70efe16902dd6da54bdcadfd6a3ceab8dd27b1e833c"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end