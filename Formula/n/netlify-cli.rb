class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.35.0.tgz"
  sha256 "3769ebff7b6a0e43685f9b08cc83802f85a4871d7a83723c1f1f3eabcc2626c5"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "8113e5bbb50d43eca66b1a3f7727ec74282addefb45d51989bdb552763fa415f"
    sha256                               arm64_ventura:  "6d869ea9107c9be60eb55ebdee00c720f1928b28c6847253564470d7cf5f74fb"
    sha256                               arm64_monterey: "762e8fe728b7e34ea25fc9d939748945c8e4c3840868415a3d91dbea310889d0"
    sha256                               sonoma:         "15141f5659cda1b5b9005fbde5e1f90def7af30a81897b3f0d68b6cd9120b830"
    sha256                               ventura:        "67379cf5e1bf08e9e4de045715e85f3ae2e500c1a1860f72c643e8d996e63ebb"
    sha256                               monterey:       "aab196499dfc0a8173c3d2defb20f1f82f42076225d5f3e7710e78a9ebba2ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b8374cc0fbd59af199d6dfaae23a677dbce007689d4ce659b9ba9f367fa350"
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