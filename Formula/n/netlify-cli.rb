class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.2.0.tgz"
  sha256 "4f0027889b3d66eda9812bf37c4137da10d4c0cdcdccf8b9939c42ed3e7e1735"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "8d39ffca898092a9e29cc87ce8e2d943234d24055434d51ddc63ed250622f2ee"
    sha256                               arm64_sonoma:  "32ec6fc0c57d00ed51dd1303d709a4c2bf3101f5202f785540dc3488a0c46821"
    sha256                               arm64_ventura: "7ee0fecd2437817fa83c0dca7840814e277c80f083b58e543bccff3621987bad"
    sha256                               sonoma:        "69be68a11fbc3a563a67d183e1a43d574f5dd390f4fbb9785feb6742cd9628b2"
    sha256                               ventura:       "e4a4f4bd458bc5150f4cd01b7aa4753782ee834dba3fd48ed73ff666a96b3626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c185c774dfed3cc005743051ab3033cf1afa0339973ced8c7671f3a0b04c508d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef51a9a46f80cfad0caed148655cc1de6f8224c931777415ad47e385127e0da4"
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