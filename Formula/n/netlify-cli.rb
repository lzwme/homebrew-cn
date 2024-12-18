class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.38.1.tgz"
  sha256 "0f10e92bc575316b8c6dd91fcd52578194e7b6d105d4cee36947ab3e4928393d"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "9d2c847db41c9eb7bdd5bc0f120b7f0e928752c52d9a13bddcc8fea61cbb1981"
    sha256                               arm64_sonoma:  "3fa0d303dcdef0e17d117c58507c0a27867787f72fcdf950c9c2fc12122f5f89"
    sha256                               arm64_ventura: "c6cc690a19ab590c2b4024ec99b2d416274ede6a29f8f87bd348b700cf2b7b68"
    sha256                               sonoma:        "026aff42ba440e828fb4031dd75ac662981d271e61fd72fc3e0f4b0a03e058de"
    sha256                               ventura:       "f6b4f3c12f5a06391d561b65dabc3efe902f6064825714a8d551071742b7e01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e499bb48179384a0e838508a03bc205baf43df0ccb413dd7e258cef26b9db416"
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