class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.3.0.tgz"
  sha256 "70d11b15656e2266f06c21b333dafacf8d480136f7e8bf34eacd4cc6d35aad62"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "c7fc53a26c5315e43480c4cefa36c9560f8dd0460b57079e9fca27be64dc23f5"
    sha256                               arm64_sonoma:  "38f7211c4551ec43783e10bf19c754edbd564e117ac306d2386b3f495398c9ed"
    sha256                               arm64_ventura: "cb63a58002dd8c1209c594eff230fa35b40a3e6da862342001e3c782760719aa"
    sha256                               sonoma:        "b48ff71cccc25e2195242fdb8fa59f0f6c09e358246cca945d722e4dde298dc5"
    sha256                               ventura:       "56f0a95e99c3102f05945f7393181519b7813e0897be2af64d2ccf760057d021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abad1905dc0535640cd5f44279ab83c2a781818a68d559de5e02243d002c4296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e983e0ac3fee869b838a5e10f480e88ae6f9b86718d89d0632a51706c95950"
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