class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-20.0.1.tgz"
  sha256 "815b3e999771415bfdb3845071b200e4ca53715d1ac11c3f322bfa088dbb92c3"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "c064e8989205c5ed333d62c5ea5ba15bca76bb5dc84a77931bd85d0a8661a7b9"
    sha256                               arm64_sonoma:  "14f5e19ef95583e9fe02748cf6c0c7c84b69eab8406ed792144bd5e59ed8507e"
    sha256                               arm64_ventura: "2d12036991c3851e001bb5ce13650eee44224f143790573f9d71632d2ed9acc1"
    sha256                               sonoma:        "e7a4ac6adc9efac75cd3396c57778e29beb0a6a9c106c17ba32be30aff568630"
    sha256                               ventura:       "35af7f770b5eee1cda2fd70eac88a31a6d9a69d05bd9b322ea3acbf555443245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a0477617a079994a5d8dd6a8f601501822cfd5dd902659e4952d0aa917de85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aeca923e8cb9f42e1f4e339ed0054ab723ca7cbb214bf3ce03446957404caf1"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

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