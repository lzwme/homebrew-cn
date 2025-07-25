class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.4.0.tgz"
  sha256 "e90a2d54b6755aa9f0b4c4f1a6eb07f3a4926fb869d82f4c1b9b3ab1847e3ea4"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "911f82bdf0141be98923c93e3ca01171d46b047c94d4fb5ca63c6b376953b7ca"
    sha256                               arm64_sonoma:  "77e77c2375389ce39797e6bd614c13af3576de24f8f8222e26cd8d03313a1630"
    sha256                               arm64_ventura: "e0e0ba7b688e5dd481cc00b439146cfdbf9b2e0e2e52cdb4de43ddfa5f8e2a99"
    sha256                               sonoma:        "5d7089771c5689f6d5f281611aa7a6d8d50f1f78b72554b3a749d367b1244668"
    sha256                               ventura:       "ed7980b05a244b2e1320861d2316aa9357c67cc67362628ed446e8642d052763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8371b31b4fec4f3ab0e1528857edcfba144a7a60c6e0839b77abc412b02cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d9a4af04fa28997d8eaedaa930480360f44c941c4eaadc54b0da1ff5c30e2c"
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