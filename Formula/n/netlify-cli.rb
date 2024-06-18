require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.28.0.tgz"
  sha256 "dea7a05570fb485c8c393ef4c3b28858a8e17fe3b7d33976e144163a263bdb2b"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "0ab246a37df528769b1e296a4230acf8189733808e01f9960561d468791a986f"
    sha256                               arm64_ventura:  "1d6dcc7df5e1c017b5e9d1b3401cfe9c64dc3172c10a1d38a691220afce43b4c"
    sha256                               arm64_monterey: "d5a3221dad2fa0442979db47ef96474b98aeac4d6ff11d4b7ee5f85c1c2cdcec"
    sha256                               sonoma:         "6f324026500780c0b8d135021bced0bede605326f8b53fbcea157733cc0052de"
    sha256                               ventura:        "81a53f0e52e4b2029c2c49219353aeb6ac70cde64f6dedca0b3808e4dd7f5e71"
    sha256                               monterey:       "f63e810f41b2feafe28fd8d947a2af08095ebfb958724df6e200da6e3905ebe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47345eec1634b8b2b003cd300d79e93f8b389799c3cab076fe573de83a9a0ea"
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