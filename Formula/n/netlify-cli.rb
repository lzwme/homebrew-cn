require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.11.0.tgz"
  sha256 "e272715a6c3fa5150486476d1258c629fc5de7f611ece8d82d8886103731612d"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "2d65bf5411bfc3503437facd2c76e023cedcf38343501eefae80593ec447502f"
    sha256                               arm64_ventura:  "5a1981cfc01e50d01cc908a619b36a29244f15f444dfcb0839bfdf6eee6dbeac"
    sha256                               arm64_monterey: "932ae554d74c03177267093cb9552893294862ac4802eababa4b637eb2f04010"
    sha256                               sonoma:         "3d5db3f96815f8fc4eeaa39ac07d2682fdb71a5d0861bc3e2bb9cdca23d34c41"
    sha256                               ventura:        "7da02f8d8f5e2ec406389dc877ba2a309ad8f3e1171912a8870b4c5afe21caf0"
    sha256                               monterey:       "df89adc60c4b870579f972a0d754a05a9f74c29cbc6272d2bb6bac8d53096086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5af09cec87d90822b645b5d1d277370a788df8eae374d96b01bfe40c19011525"
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