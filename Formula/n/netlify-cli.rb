class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.9.2.tgz"
  sha256 "c40fc5cc42866dc8f242c2778f849b80b256c12418b50628a21a3d938ed51ce6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "36e140db235bad8e8be24528139b731da37511eb3163451a1ff47f6406a3816f"
    sha256                               arm64_sequoia: "1c767e8b793400ee495c102120c0acfc74b84f7d742ca157883bfae0a0c03f94"
    sha256                               arm64_sonoma:  "8f0d1b5d8acbdb1d5b0e8e9d2d5a19e1f7cc4ce38cde1b266ca80f3a69a4b2fd"
    sha256                               sonoma:        "9d71a8ccb0f00a33cfbc1b7c24a5deea841b78eedc68454796f828b4c95eeacf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebc5b6d82a3eff18f914d241b0b7420b0f779a7c4cc1d08e06476329a850277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b54b0a5cc0000923df513fd7a01c0b8bb2c712516799a0c2aaf94810c8e678c"
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