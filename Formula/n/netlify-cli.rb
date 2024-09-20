class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.36.1.tgz"
  sha256 "6ebb731bf5e580fbc5ef4dddf01bc91f4dfde672feb1ca9a2d91ffaabe52ec6c"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "0befb329bfd1dcf90cf40a38d88275976d31757c2dcfeb7fcba16356e45acf13"
    sha256                               arm64_sonoma:  "c1b955678ff2f94cc3d4d5a4c9ed252215893101a6f150b480c7ddd52e984d95"
    sha256                               arm64_ventura: "752e1b647241a9d21e932f0fbbf89db5212abc210dda93dd5a62157895cf449f"
    sha256                               sonoma:        "7f30abc5f6e50d8a6c7eaccbc8c797f75e6ae6098efd740474b304b543b142a1"
    sha256                               ventura:       "811adfcc07209232b327446f4f33a3f3da7247deacc613b5c793317e80f07799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc85c724ea0f94e07e9eac3f08f346c719bef1a9f614e23ac36084833aa15cea"
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