class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.37.2.tgz"
  sha256 "8782ba234ad41c72bfaebb44c3a7345e4149f1b9546e377215b879731970264f"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "dad31da3315a778200b90037321e8be2a0a9f19e1e7707c8395b5855f823f088"
    sha256                               arm64_sonoma:  "3cedd418c66c8613136a6690d00570ce2c01c7a09cb646a74d13c1837f6aad8b"
    sha256                               arm64_ventura: "f4e23e483fb471b12209545d8a726f559e41b0ebc0b7b5afdaa2afbb292d0f8e"
    sha256                               sonoma:        "785614e128209f9e4128895c13ba8a35ca881c0780203b5be01434265cfe43cf"
    sha256                               ventura:       "385ec2bbf9eed1d817855772dd097f029f7c5b759beb9f1d5a1c72919e86d743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34d9b4000358f60dfdd3a76eadebe5b5fa9be66cf30c7b567a641522d30a088"
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