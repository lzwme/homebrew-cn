require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.11.1.tgz"
  sha256 "473c655b668ec1d96ef4a30d0a7401d972ebe0148b33c2fde03f57ba0ed27f4a"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "9fcbe82621440a51f721b7cbe0a334a55916a0b157f66153af69d643388e1905"
    sha256                               arm64_ventura:  "150ce03dc0a7ca0cb4932300eca706d74228b6ca346788e94cff35b7f22dd28c"
    sha256                               arm64_monterey: "881c95e9cb6d0915019c60e68282e8f91decfcccf5ac26ab429d60c8ae2f8ccb"
    sha256                               sonoma:         "0d5b9efe55b1d04998ea4121f22c4039c721d47b0c404330ce988044bc963f25"
    sha256                               ventura:        "12347aad5854e5ab45d80b29967ab72573496cb189e9118bcf824e0331361938"
    sha256                               monterey:       "bc48b8d80c167b1e7553a546679b8b4706821279a733c90e7d7a12500d6d4c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f7cd5e5e8dc8006330f37a685311f32a8081da7e99ad4a40603bc51338aaf0"
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