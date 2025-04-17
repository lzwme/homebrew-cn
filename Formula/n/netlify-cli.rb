class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-20.0.2.tgz"
  sha256 "f1346fe4ea9b947b1897273e523d3edee1b12c6a99af3f685ffae6cf5ade7a2e"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "7b66ae8a6fb70f4dc1e97cceff42b7a949cadbbe412c6320c8510044126d9fc9"
    sha256                               arm64_sonoma:  "2d5f9d0d0b44b684645f9702f33a2e6ebcf16965dc319d68321cca7470ede8f8"
    sha256                               arm64_ventura: "4ab6035607b34ed378e21c5d3e8c3a1f516a6b698e66fdabdf77d7886bcf0824"
    sha256                               sonoma:        "f68a3def2e242270ab5321579555947e24ef34846ee21a3b71d61d48ee1545ae"
    sha256                               ventura:       "d0c507f462e65ce93cd0f0d521a0e60bdecb77682a830bc8105b7cdd470b7255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cacac6c1a2241eae24f808b7ee015e67254731381733dc6e137ba1844f875808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffa88bd20a644814e861043ae2b52ed94b8626d99ea4396f68cddfc425eb838"
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