class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.1.4.tgz"
  sha256 "3d569b56f27e834dea2a5b270a87d1fca8422613accfe9750d1300b08801002b"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "a2984a0ec6b96cef531fbe47ea84b6e6247bfba06753a6e069403ce26d6dd420"
    sha256                               arm64_sonoma:  "d859056a1e3019c91b4422ca86176339227cc21542cd7c1252343d0be933a549"
    sha256                               arm64_ventura: "684ed166bb9bf943fd0903428899d710613649840e5ee8245c78b67872621878"
    sha256                               sonoma:        "cfb66f0e857c1bf9502808129c94f58915bb35a31466742197b7e942920e3271"
    sha256                               ventura:       "be6f2584216351f01f4757ca2db03360d10108a9cd3853773ab32f586ad6b131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b80c93f47a9d395fba5c3a7b43cd998dd67be765d791c57def9c77acb174c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7cb42119b9450b0d5c1811f891d2ff4f72dee79ec2c026e928d370e9acf34c6"
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