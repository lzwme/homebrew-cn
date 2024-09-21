class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.36.2.tgz"
  sha256 "238df95815c59a17e8ff20c113d0ccc5c05b756d79bed4666257811b389085e0"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "e87dee47f9f45cc885c06ed036437635759680a9a8a88fa6d177bbb027fbcd22"
    sha256                               arm64_sonoma:  "4150869fdf9078bac3f4c8ba345d4464c9f14856a2c4fedd2f0e94607b3f20a8"
    sha256                               arm64_ventura: "d50f907b1ff490f9e7d25545168f7ff1153fef76002ef06dad82ec87b9660a0b"
    sha256                               sonoma:        "95fa4416b4405fdf3b4405c2adb60759f31c594b8e351ddf0f418557fa4113b4"
    sha256                               ventura:       "bc4e6c0be2554164214eb510136fc5d2c8257d6d0e8db7c5bf62c74091b2b236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a0af9b0aabbc1d49077647fcb3fe83c3b375fcb5a39ab2a7e6dc4ff86c3ddcc"
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