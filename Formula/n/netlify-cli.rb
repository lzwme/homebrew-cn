class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.3.1.tgz"
  sha256 "f79c49e0dd1835b333005fb93870125c214768b96f951fc9049895874eee02cb"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "e43458fb386e1634484a2ea7229061efd5a26b4505f9388f43eae80b12f1f71d"
    sha256                               arm64_sonoma:  "e18320f1708f2747cdd459f03a13c79af650f0566d48fd0b2b0119eda8346b9b"
    sha256                               arm64_ventura: "6fe2df744089c35497113872180e0f06bd0ff6e4fff4a35280582f9d15b27df5"
    sha256                               sonoma:        "fd882b84d6cea2017cfa2736b65f60da83f3ddd1bcab7de2b907ae58a17102b4"
    sha256                               ventura:       "ddcbac7fe7b34d5274f902674a3ad6d5a3001000ef393008aa05b2e0f87fb46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b36af2d79d71434bde6260b781831376d71efa9d1d71f93aeeb8e8709264e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a9321d8b74b6ed563a220332a948f31f3c275d45d5a4a7396d4297467f8b78"
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