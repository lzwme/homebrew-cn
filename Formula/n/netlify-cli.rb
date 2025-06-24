class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.1.5.tgz"
  sha256 "1ea0752681ba454449ceb3d4ac69266f6d68ab52ac97581bf1540742249dab81"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "60861d7c03aa5450568e456aa6c86b13a58cfcae0353d56293712f80621dcb91"
    sha256                               arm64_sonoma:  "234ec66bf09325f9a7761c656ffaa7e6d54af0805bd34ad6c432d48b3e730469"
    sha256                               arm64_ventura: "700ab0a0fce188bb025f5870c69dc42f483d1ffbfd1d07311f2827e365fa8e14"
    sha256                               sonoma:        "c6beb4bd4c7aea27ac74c2ec8855c1c01d0698f97865d49d60b369efdc40501d"
    sha256                               ventura:       "c02476a92f67d1634053863fd63fae65902a4f7a5e3c1d44b620dec10eb66747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b531638e63b5fbec659558b71cc0b2aadfd9bd93cac82598afc777d72c26b88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2921bc10f2917993b248b7faa693df36439deb46585b9ea0f58f2314f2d76ca6"
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