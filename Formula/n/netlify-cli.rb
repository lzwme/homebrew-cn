require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.4.tgz"
  sha256 "b201bd413f70247923ed7fe9876110527beb18b4f9d23419d0d3a28c27227c2b"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "dd92a556271909ebda87f99c93e8799c4685a97b0dd9e53accb4d5cb87411206"
    sha256                               arm64_ventura:  "05d2eb15f2ba42f2efa78527adacd2a46907c3e11a575e04a2ad9560d841809b"
    sha256                               arm64_monterey: "a34cff1afa584ddae2fa3315f757449449458a5306f44a085a28947926d1a8b0"
    sha256                               sonoma:         "616f20cd8123753e8449abde066d996b73c076e291d3085ee72bb4da70dd447c"
    sha256                               ventura:        "1be11b1b59312ff202ff93f08321f043926c1da3b5ee21319c4f8de0f4340aa8"
    sha256                               monterey:       "1680f2b2a0b0fa93cb2136ef89d9ce302f4b29523bc53b3b519fb21acb734704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f8bd720207a2679bc4dd112712b3a1419c9228adc5b7b9cb556993246a7696"
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