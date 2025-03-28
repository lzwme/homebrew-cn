class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-19.1.4.tgz"
  sha256 "0d516ea1220f58053ea5ccee078a743433d8c4e082ee27b28a15f51765464f22"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "3da4ac627ef5a5ab74b81f58d3078c6892f7add1734e23a6518644d8711dc09f"
    sha256                               arm64_sonoma:  "7f998137cfa01d82f4094bc9eaa9f3b73df8d74f2ceb9a41fb3c134573cb1a0b"
    sha256                               arm64_ventura: "4b3fdf38246a398ed0b5b63187cbbfe36bab409cbb32dc1564af0c26293d0645"
    sha256                               sonoma:        "3a0e845d223fc9c0d34fbdfe1517a8e7cab540b7d72c563f7412ff24c43ec0b3"
    sha256                               ventura:       "45310243e4d1519f15b6cf54840c94409546e6d57019b3f5b1f1cdf178e15118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82ddcb19817641ca892e5eed8f7719dd2aec24187b74de2fbae18b743c1329be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5e08dcc8942d2d03d19978fb230c621b16fba87109ac6825895006c75c4798"
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