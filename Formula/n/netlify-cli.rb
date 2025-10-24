class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.9.4.tgz"
  sha256 "bc2c98ee35cdeebe13f660b37e1eddb99015ed5401bc3d19921abdfde4fc6735"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d2a8b677dcc079d40eab01778ba2fc51be54ff45db133fd83f5e7460a845a55e"
    sha256                               arm64_sequoia: "6a2fb628a466d766b969a8634bb01a83511118e663d2c70b0aba6c6fa5da0719"
    sha256                               arm64_sonoma:  "711dbb2983aa77aed530a583d089388343682fba4c8c7a3d52cefe79b37b33d8"
    sha256                               sonoma:        "b9f5971b44f8b3ddd2f91154ef83283f540fadd9c9694fd7eefbc005938213cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7f7ba9bf2aecb78f66c19fd4788b0069362b976057d60ebe0facc2ee202e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fcb991f3fb7291bd5bb64fe335a5f32bd2eaf117e2f23b77627fb8c2f855cb"
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