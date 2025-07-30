class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.0.0.tgz"
  sha256 "b926d0c5a19cdb238925b316f0abdd7ed6b5430c0ca031bd2d63ecef5653913c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "d729c6e6793a7e6c531cc395c35e27408a5e4b4fdbceebf12985d2598eaee1f4"
    sha256                               arm64_sonoma:  "4f6f652d4fa525cc0f68123d8e81d3c9b3104de5d63a951adfdc9a4d24014379"
    sha256                               arm64_ventura: "56aed863ab7517bce6a07f1c36d339e91916850468ca0ce4f3fd517824fb534c"
    sha256                               sonoma:        "e459e763ceb3bf88e3ab7f63b36bb5789f7fcd9062fee57eb6db10992cdd3c95"
    sha256                               ventura:       "94ea0777aa276d79aa8e2bd680705cb13fe12b4c2ddbd029fc9e33ff937a516e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f94b79ab360257009b6bff2bf233089de9fd840309b1b767f55a2117d775b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb463d8640dfb36ee553d8987bcc04657b94f8aecc9998814263840aed175d2d"
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