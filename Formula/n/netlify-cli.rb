class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.34.1.tgz"
  sha256 "02fc91c36cb242ed101e6d975b962d730fbd1ce860de9768c5626767ec8e439a"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "3f9772e9e178d742983403f671556223f26abb50b643368ead791467806804a6"
    sha256                               arm64_ventura:  "6433a6d32b8524d3426868601f81396ace1cf8099d2f8056f928b41115725b43"
    sha256                               arm64_monterey: "7091f0a217f835d76af92963a6c70f2cd4835485dd09376f33eb7cba934d91d8"
    sha256                               sonoma:         "0987d067b0110ce9d1b15dd407cb2ea48db7b6b431a01fe9f78123ed1dff40d0"
    sha256                               ventura:        "b5928f4afef2227682e4a5373977b7c0e7d620289e261ae742a090c28466fbce"
    sha256                               monterey:       "c22bfa0ee397ed411125e0d1684767b2aecf748212e71f6150f754edd77fe924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a0aa750a2a7a9f5811814146541c50e3335f1f9f7c17963b0ee94295868199"
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