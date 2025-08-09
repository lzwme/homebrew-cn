class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.1.3.tgz"
  sha256 "ae9751c36259dfef9b70d25cc275dc044a22264367ebc9b6134e2fa0a53ca751"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "fa560eb02b5b26fc34732c3b45daaa16525449bb31409f851c4fc17668cd1728"
    sha256                               arm64_sonoma:  "9984f3bdc6d45cb7e25cd8f23da6693493ed95b5842cfa5eeb36d2b6b12563c8"
    sha256                               arm64_ventura: "52c4ccd8ee7ab8b4e7106e2d248f7729b7f4f84107f70368a81f9d97e4ccbfca"
    sha256                               sonoma:        "83b2d8eb6767182d5d94b2237b736773c551c5f79d1f5fd8875fa9ac56c9c678"
    sha256                               ventura:       "1abd62b13b289866151d90e0cc0d9e917a7cd868a7ad406a1c81f8460edf8371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eba5375316af946b223f3774b0a05de3d9da0d14d0fb1d23d398f030e5ad43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6288a01b9f57cd6df62a50e825acd25c6873eff792757ce4c1b8f8f2f56c8c4f"
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