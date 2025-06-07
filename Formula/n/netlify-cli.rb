class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.1.3.tgz"
  sha256 "08a2fa4599dda341690779fcdbc795de7da444094bd775014c66ec0d3474fe21"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "f51fca6764a6ad40bbd7a74db9a6100f3222e2aece813872bd3f8165a25c4ec1"
    sha256                               arm64_sonoma:  "abe91cbfb13c25b0dcce9f91d247d08f9b3e600a86ea628ce7269734c33194b1"
    sha256                               arm64_ventura: "cbddb1b8b0669657b862a885bc141ffaff826a6c87295893b1489fb886e8054f"
    sha256                               sonoma:        "ec6d41ad02576073eca3c88c15effbf9ba8bcd6e32b08230f58c92d6464964d2"
    sha256                               ventura:       "9e0186478b648b1070783f88845ba434864bf0868fc94a2d05d73bd009d20623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71577fe8c9caa3a835090e0766322dc1fc0fdd8ec9ad683a618b55c06c6ac034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8e96412b64ab86100896007bbbc49ae40da36a0c9144c650d98e64dc93496dd"
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