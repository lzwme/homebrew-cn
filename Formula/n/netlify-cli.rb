class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.4.1.tgz"
  sha256 "b943208ee87535642fd7adc427a541f9f7295b53f3b0a0829e23a4e57c47469f"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "f572a28dc195b77a2e9e19c240c9d26672c77687b677202b14725bc603561133"
    sha256                               arm64_sonoma:  "9cd4d22fda9d2f2cacdf24d5ddb936100eabe42c5f0806049088d78a007ff8a2"
    sha256                               arm64_ventura: "864faa364a88408ea353e57166a7132745a19a2b0fd0d6c3ac16933a41e88b35"
    sha256                               sonoma:        "df880f939fc59e65bd85ae88a50a7bed0fd3fe7c210d2a510240ba1eb638a3cb"
    sha256                               ventura:       "c7b8a5f3d3b8247e6b1fa4e260ae4bbbd5afd61089ca01b2a02a3acc25e80491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c33daf41c9e78d6cbd1b5549d677a67a92c0a86b8f89d3fe0fd57af37bd9a89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f068ada3eb7fe05502eb618545c92918135cd3eebb14ec34490aee14285e4fe"
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