require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.16.1.tgz"
  sha256 "8f94c3478f4054cb08298f5ea5e2c89609bf7a47c1aff0e04729262ba4093800"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "a7a993c88729425fb63e39b0b191705b3a28a42e33ab8529b65a23ea2b55141c"
    sha256                               arm64_ventura:  "ea0dc43150c2c8d4a111e444cc85ad99b5326f57d618ad2068916bf643f0dc6f"
    sha256                               arm64_monterey: "36c099a5b02452c672c939cbb6bea35373a5ecd18e5ec327f504bad84d71ec1d"
    sha256                               sonoma:         "91fa0396c837a5b54e8d9550b9ae27f134926abac5ac278ff99717344ff18129"
    sha256                               ventura:        "0472deadc431f691e16ac7e3a733b32607dc81756fef2a26278e423f876179b7"
    sha256                               monterey:       "ab13c42f33edde503b35adb2d0f8d64bcf335ce9d1aea38a400bc21cbbf032eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcef7933abc5e2c3e8dbe16e3d41d413984906b56f633653f4d04e865e9cb49"
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
      (node_modules"@parcelwatcher-linux-x64-muslwatcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end