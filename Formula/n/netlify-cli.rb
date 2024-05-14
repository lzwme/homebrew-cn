require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.23.3.tgz"
  sha256 "909a817b91509dc009fc466c3eee572fbcb0567ce95d8b7a4f8449da4802c84f"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "e283fef7623d3c6558e828168ba10756d19495a52ff183e6251faeca720ebf43"
    sha256                               arm64_ventura:  "0aeedb17d32ebedf6209d7ec31b0bba159159a8932cdd940b955187f7c219b37"
    sha256                               arm64_monterey: "78b34c369248ef42f9311f1aec721a8d45991786cf8f67a4bfdc97dc0cbcfcf4"
    sha256                               sonoma:         "97baebf608a02903122507f6c0af5edb9d9ad8c08a470293e0d7e78cbf764ddd"
    sha256                               ventura:        "bfd2884e1cc397fe6a6a0976da25443cd0338cdef26f9e6dc937d47ba1af9f3c"
    sha256                               monterey:       "b61b3f8ede484dea6cfffdb080cd4983f254c85e933b101e415987b3d4d2d682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291f73bce8ba1501cd8863c6152c0097573eb67ea59bc52340b9b4bbe1d51251"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
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
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end