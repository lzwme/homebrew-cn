require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.7.tgz"
  sha256 "30d0e4232c2d8b52770a31ee7d7869ce902b34527e4fcdf23ef4a3aca75c07fa"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "4d0428bc528722c0282a1f84ebd25560bf762a71df08283fed23f7071c1e3acd"
    sha256                               arm64_ventura:  "795a6c8af8e6cc0e5048074e1a5c3b2c3f66551ff54d2c856685f2065dce1ded"
    sha256                               arm64_monterey: "626b5b378d81bf90af73075144e1b276eee0942b57cbf792910cd513ed336ce6"
    sha256                               sonoma:         "57125a3ee1ee7c2a9d01656a5288f313a3603756285928db5b1f14b50c626c1e"
    sha256                               ventura:        "6a1b18fac4a3ae038e444333c02310809487a742657037c77e4db6eee352cb02"
    sha256                               monterey:       "bd173b963ad13c98726c8ad86b6e0014bd6f3f09442d031b1a56bdec397894b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595bdb808749cc2c884f276eaa525ff3371a55102d4a62b90dab8ae69dbcfc50"
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