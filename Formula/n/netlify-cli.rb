require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.3.tgz"
  sha256 "868377851a052f32becf72cc86c3be63fc09a5c14891162e64c9a69c31595abe"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "ff8348ea102b6ebf1c85dd8eb23b5681dd6a17b2ea309150b7c2b89087e132df"
    sha256                               arm64_ventura:  "ded7ebcc14746dd34405d62643d1a3884d5c84b645022ebc68a075cf0d396d18"
    sha256                               arm64_monterey: "956951fe7850775d644650c30c1d50ff1ba0b59f0e5db64b861b647741224ecf"
    sha256                               sonoma:         "4fd0baf99b3800d13a364404273bf8580c665adc64c6d3ebbcc9e77661b726f4"
    sha256                               ventura:        "0b7c279077a8418c9cf4e21155ba681e11aa58caa8c51b65fc9d2519df22ccf5"
    sha256                               monterey:       "e49a984737e341a53674bfcd788c00ffa5f57620d77e097c765dbff7efed83a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce43c606bb00915cff97f5d6047e69cd7cbe91587271f26b2dbd53a493200f0e"
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