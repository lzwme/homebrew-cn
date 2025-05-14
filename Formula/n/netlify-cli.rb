class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-21.3.0.tgz"
  sha256 "75a8ec9e3a25aa4fb6bdf3272eeaa2170e2877ed468601304c9ef05342fde322"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "b1d2e02d56bb065075590984be68f4b5857d6dd1bcd5e5fda02ca54661d53ac7"
    sha256                               arm64_sonoma:  "7efbf8ba901ab14a96a5900f02b9ba2dee54e9ebf99153424fe5b86efa0d372a"
    sha256                               arm64_ventura: "f34e908bc10b8642c6fe587fb9f12f9c4ff50d47c8591d857e3fa12f581fcfcc"
    sha256                               sonoma:        "73f682e0f6a7fb4e59b3d822c5e317c5e7d315b33ba6c044e2f7406eb355266c"
    sha256                               ventura:       "938cb5c52bd2f4de1df7c48fcbb9569cea3ed7aa775d84123bd202c47638a875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb9438769797ca7386d4c46e1615148bdccb05b98848b0bc39e65b74b7a4c5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187a9cdad20fce0a853780eebe3db3b8d95be0100cdf2170c24d79246141f61b"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs``bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end