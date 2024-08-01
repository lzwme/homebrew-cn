require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.5.tgz"
  sha256 "fa58bf9937752189129c88a576805b6ad13756beee12728569a9eb8261950a20"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "eeab8da9b3280ff607c6d4f40000446d038e9bbb6367fd3c88b3ea323fb351c8"
    sha256                               arm64_ventura:  "67f91b0d2d35815d021c950ce3a1d9df39ee32b2c70ec7a8ab8431cf9f577e70"
    sha256                               arm64_monterey: "c8393ac814efb467905e199bcc1f289d5f27f9faeab3ce433eaccd7b0806d0f1"
    sha256                               sonoma:         "f16612c3210e92c913ca16bc549847f8dfde9e653d04405f20ba2f797a7c6d93"
    sha256                               ventura:        "86db4634c019d342c15b90876030252cc454cecc83fb9b45f89498e1a3644422"
    sha256                               monterey:       "7217e91c7445674a6c17b6245c090cff5a829e3d0d0f076c5f9edc7b418ec64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01258212a66c3784377f45490d73e00254521e3054d43624dabf3933d823c0f"
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