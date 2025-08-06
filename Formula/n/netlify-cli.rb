class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.1.1.tgz"
  sha256 "f314150dc16671d84024bfad069781509ce8f549b2e221055f8e321996d3ad5d"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "05beab957cf8da409c7ed39c90f7893e41217f42ed087e078379ce8088451beb"
    sha256                               arm64_sonoma:  "bddb98e9f69298f2915e66016f8f6b3a77e8057fa3466dffff8f7afdf386fa7e"
    sha256                               arm64_ventura: "1ceb8110b887c048e718864654d95f41a03f0b304880e4e8f5f867fa7599d11b"
    sha256                               sonoma:        "344903c61da47909289f915522b5560ebaa7801400ef3c4b4523d2e9631ca70a"
    sha256                               ventura:       "ba61d4a3c558fff4d2a6c3e267835cfb086642ce7364d242287bc5868dc71ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54ee10379380f3353ba060d42f6078e0716d087adfdbc95ef8a2f9aa9ff6eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abaefa98de1f6c2b047e1cf2a8bf0a403c803f4ef53ead3cdebeda2f72859b48"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end