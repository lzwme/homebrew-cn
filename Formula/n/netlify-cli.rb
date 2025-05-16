class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-21.4.2.tgz"
  sha256 "585595eaf343e03cee95402ea8c492dfab4f128881c296a872a82307ea21f01d"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "81b9175167db2678626ac4f151a7856528c6e9fd1ee86744fd3dfcc93bf89ddd"
    sha256                               arm64_sonoma:  "7d7855e3a619acbdfa5cb94c97f014196617c180e4b975e2f5ace19e96e2a629"
    sha256                               arm64_ventura: "c72b88ea20e0e98c32a01ddd4d689ae97fc0a12aedad455c9668c98d928ad32a"
    sha256                               sonoma:        "5249580d5d4269240cd33a64d4bf5fee6d31d07721a6bcc438d02eae6fcbb84d"
    sha256                               ventura:       "15cd6ef632b4e85768ee7dba80d4e71d8f63f57039c382553be041f706e6389d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e5f70e0bf3c6c26a93e1a4fa60836c762e4f4922bafefece285a34ab62d362d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef19b55d9270a4945f4589777c4589f8275a1de9d59b1d6770a437b6692b4281"
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