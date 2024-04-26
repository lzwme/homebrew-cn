require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.23.0.tgz"
  sha256 "f53f80c825181402e83342f2e651854352948dae4eb0cfd0397b1f35ae930ac3"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "60f65b8fc6089c285eb834a2beb1b6acc01d264a1f6bdae8e00f9c8d04c93970"
    sha256                               arm64_ventura:  "782852c0708c1aed67df66857a82fc4a71371019d1d716bfe9658275798185bc"
    sha256                               arm64_monterey: "19c72f79c3926cb570f871f792ddfbb8d0e448c43e89d5811e115ca6607de4f3"
    sha256                               sonoma:         "11cedb2580b4e2c6def75a43fd56b6774b668f5041fb18077ccdfb5cae4a2abb"
    sha256                               ventura:        "b66002ede58b96bc6352d6b40ab854d24b8ab68259a4d921ab65fb303cd2e71c"
    sha256                               monterey:       "cc6319f5816f3e34cfb00eba162cc922685ccf0ef16125eaa9e9c96bd5c3d3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25bb97fc7c32ea98ea09923dc171ae9f7caf8cc72da9393ea28d224b0c3cd96"
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