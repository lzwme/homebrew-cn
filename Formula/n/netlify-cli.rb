class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.1.2.tgz"
  sha256 "bcff1038209dcc20bb2b24ff7e2024413fa99d6a98dea7f5b48d39e50bf335f6"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "febf9aa5c23d1f19b26151111c3cb83ca02ae8833502b511667455b0a7a0ae04"
    sha256                               arm64_sonoma:  "02e3d600d11c813bca64b672e34da2c4a78b5d090204cefa3ad0d4b06589051b"
    sha256                               arm64_ventura: "457dff95671bdb30bc3352436c8fd8f58aa1b320b97080173f6bef2c5f34ad33"
    sha256                               sonoma:        "60dd939615589ac4b0e24d3ab5f7a456e46bec7a840bb64632dbf42c8024e959"
    sha256                               ventura:       "15a0bcb9d487391cdddbbf538c2cfea307ea50b5913a886a137ee05b10d4b73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42f502f96137504ac23acf745f0282be7f3901af761ebab2af5fee8c7fc0c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbbd504d5b56846b1b42cbf7727ee59f18093adf0a8798ede1f24b9aa7a06699"
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