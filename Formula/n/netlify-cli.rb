class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.10.0.tgz"
  sha256 "379457c467315d08b681dfeb0519fe5ed6b29d56953ff8665a4d6fe4bfcf8711"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "07d9c4307429c57c9e760498886ce89eabcdcac397dc917bddffe5ec1ec31766"
    sha256                               arm64_sequoia: "1423de968f37d9c431ed9a080de32b709df41d69ff88b73036460b3a646e4f20"
    sha256                               arm64_sonoma:  "913db3100b7ca53111466e8bb12baf35393604c892ce18de17a411fa2e8d4238"
    sha256                               sonoma:        "af3badf70f7de6f309ce7eaa42c7aa2a62f6a1a089e133fc7521886a470579e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245a556b55cb1d9d47ebb2a8aa5e9b4893f403ac1fb380bea08fb44e46d5a6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a34f353d40793723a1fe3a4df642cbb157c74e7c03dcd393ab9b7712e2a1c0f"
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