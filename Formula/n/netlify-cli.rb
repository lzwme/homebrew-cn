require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.26.3.tgz"
  sha256 "9725041f0dc0b5ce2140ac025dd3d33c70e5676c81121e79b56a8e46bb3547bb"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "d1bdcbf7cdd5eb24bacc3eb37f95eba1b6d5385b4ebe1e632b8aca2000fe1676"
    sha256                               arm64_ventura:  "93e13eb320d14704fd219d63155910a5e9a8d3601a9055a70ae8b533e7fddb38"
    sha256                               arm64_monterey: "a78865608b36640e614fe2d17bd15247e632e48d183cae8acb1c01fc4f9ae87c"
    sha256                               sonoma:         "7c60a020e0c39e756229d2922ca899d9d06f37ea9716425f48e3888daa5ba139"
    sha256                               ventura:        "49d66586dddf827c760cd7f52775ad2d36fab629766153e8187a6917054da63f"
    sha256                               monterey:       "2c97c3c821c15d4c24172fc50b4f37885893ed8c7b7d1bda1f6dc513a1e95dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9be53023fc581e109da2b2fbc2615bf23c65484a3e9bc8f1e337e3dd2c2eaa12"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
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