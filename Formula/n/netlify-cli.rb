class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.9.5.tgz"
  sha256 "6d80f31b33c1d2b5c78f72e496f0b63b481e18a1d2e55064a0480ce9757c8b64"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fdb48ee892072aced7c8f8b644011f25a4cd7863c477e597d9c42d0930d7cce8"
    sha256                               arm64_sequoia: "10faca41878fd588188a360671b450c639bad577be4b20d19e09cfd2f5460854"
    sha256                               arm64_sonoma:  "70b68b1fc5998f358fcf047546e27d4c6de024971d3c37011d97e132b82581d5"
    sha256                               sonoma:        "2d341ba1cdf9ca74feee40c78d56432683941efdf0ef2ab40ff895ab84b3a933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d81a987e6a1f6a30abc58ff5d98bd086d4daab0af9947f042e7503378a6ee52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd60c27d5dc39a0f934c443097e887ac00dc32d6fbc97cb716568ed0d305c9a"
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