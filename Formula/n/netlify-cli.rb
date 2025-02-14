class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-18.1.0.tgz"
  sha256 "5fca7a02fabdefe42cdb4711aaeecf6a7fa1541167650a2049cc402da2a6ee7c"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "7b9a8fc1e4504195560d0708dc5f4507250bacdeee34749a74246fdb2efe5cf2"
    sha256                               arm64_sonoma:  "eb03cd92107be0167bb71e113ad5dcf01a72a68ce2570536c6b73f44bda69ad8"
    sha256                               arm64_ventura: "f5d6a21bdc0dc701c98e710fa384111ec94194e867913615262cc2d80766e2ff"
    sha256                               sonoma:        "5d29ad026aba0bb8efae268ea48fcc70371502572c309ee34dff32330d289e90"
    sha256                               ventura:       "01bb5b05320a6b1718f75d99ae8f2e8a56afaa6af48485e4af4a31b150f50f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f2cd79bf5b5b46ef3a1aea82a3ae39c0d3cd0f42f198db9675a47965d94b91"
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