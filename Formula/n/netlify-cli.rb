class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-21.1.0.tgz"
  sha256 "3f8acdc7b72510bed02e8210caf6029c8ac3f856b1b469b476b62fec489908d3"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "129946cd7871739a8c4b847b6bb46d13654ab7c38777080c8f1e226c7511348d"
    sha256                               arm64_sonoma:  "91ce14ac348281efd13c47b9deaaf91be5098b2f8ab37ae106e2f84ef5e5b1e7"
    sha256                               arm64_ventura: "56a79f977737f67eec987b17d3250f372126366ee637465ab8f9b562a663ec7e"
    sha256                               sonoma:        "9dbdfcdd8a09bba86d3ed0f9a157c93824ac81a50ee4052412240441a2db460e"
    sha256                               ventura:       "01fb73bcd8944bb7a7990ad580626bac6c67d835b812492af685faef91e8d094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "676a5b2cb48626c917afa0cce72476658921257facb24ac8a6ba81abbb1dcded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d29f8ec454339877b14da77b0525d73843f2791faf4bd668f65c8d33f85a4b1"
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