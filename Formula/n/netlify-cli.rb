class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.7.1.tgz"
  sha256 "f0826d2336608462b46b78d842e384ccadd2e72b8cd9e01f061f879f0c6b7460"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "33f5e1724146c62269aa11b55653dde1a3836abc236c2e36ac54d6688b78d049"
    sha256                               arm64_sequoia: "5468087c9d54e205f67fd38b6169e82befdd85e4b806b1bea9af55eb530f9903"
    sha256                               arm64_sonoma:  "f0b2147bd4d3191f50cdb6dfdccc390cbb1b6b08881c90dfc60fccfc9fdb3dc5"
    sha256                               sonoma:        "e193a5b1d0c0f0239eaf58eefdddc944d52992d62b16102cf6854e7dee1fb916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6195c4888cad2391f8fa9f3143d0aa4309cd8e04fdc4fc7fa0ac21f441c9515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5f4639526bc5fefed0f6d30d12888fe926be7b0503bea5f0cd56c4c408ffab"
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