class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-19.0.1.tgz"
  sha256 "cab21b6f1a004845665ab11f473eccda1b33d79b1fd3792901c66117da9e08f0"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "df25934504a8997459b183b8fd6a1aad21c5516628686ac115a063b85c4ee856"
    sha256                               arm64_sonoma:  "09cd8d6f1a47ee20f658261aba8abdc4a1db539aaf62b335b2e908880f2fb653"
    sha256                               arm64_ventura: "7155d43f6450298117445b8657509ff40c61d71c849e164b698ea04bf05289ae"
    sha256                               sonoma:        "44c74311523b7a7165fe195683b8fb20c66659bb740201bcc107f942712f0eec"
    sha256                               ventura:       "aa7de2555aba36ccedda4160a968a5a8be52074e8922379b46874b38883b7f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19bafc2cb71ea08946d4dacdeedf72754e8c82dfa023726c582738204736ccfe"
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