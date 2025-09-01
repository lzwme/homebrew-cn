class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.4.3.tgz"
  sha256 "0f77752d9f6ba415a3f4d91b258ddcfec7ffdd304ebc17401fb4e871c2993e44"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "1551051e2f8118deded86ecba48833d5c13d359d3f8a49ad47ec85c37ab2c8bc"
    sha256                               arm64_sonoma:  "a223b1a88d29c13708d021f5816bb9b5d742b8d9ad0704926ea92b96f67467df"
    sha256                               arm64_ventura: "4f8a01f4ad69af02a140328a0a3c59a0af88cf67ce7ca590ede206d95d8477ed"
    sha256                               sonoma:        "50e03ff7d1bf79a6f96cfd598629c7eef170c52b4860f6fc6008bf53f3eab91d"
    sha256                               ventura:       "e4f8890d21956e013a437232c14fdb07b0c1567b472a48788655033efb55fb66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6429e846dc8b11da0edea77eadda061f8a57230977fc6dc0f241119272b254f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f645fde0bc630a4da59ec34ca2dc57b62eacd92f4a5e00676cbf00aac9615704"
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