class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.34.0.tgz"
  sha256 "5f47aa2e7eacad7fda5ecaeba1b450fa603884998c0483cbeb7b8be13b992405"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "f684521d51ad3e8f5be1186a7ead0985b0ae7c24f10c54e80de9f7be1ee04c05"
    sha256                               arm64_ventura:  "9ca47f1fc86beb3a821eb88e110ff6477e757e637739c17ba62ac4335d5fbcaa"
    sha256                               arm64_monterey: "723a6c983918b5061d722639f0e423328460629cb57abda61b811a460729c53b"
    sha256                               sonoma:         "be360b8c8d74b8d5aa3d0ea8a8d9f41f53a14f8cb9e7bd61ba66530050ce7ae2"
    sha256                               ventura:        "cc512ab8adc10be26e2694db35657eec6e9f9e6f2242c3c0d5ca35481582b5d2"
    sha256                               monterey:       "4cd8ac9fbe62fec66d03e651c29397fd5884879a20496d5592d19e6edc01df34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5387b807777614f91b2601e6af471fb7665e84a69659f3cf434c929cb88674"
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