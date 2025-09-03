class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.5.0.tgz"
  sha256 "623d02518b2ecab94eba37bb3e367499d069b250db45e1ab10c2fabe9b8bedcc"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "3f5f8e0baebc5b79f334fecf0f21e53283fdad6cb2c47e50ef17bd123a87ad08"
    sha256                               arm64_sonoma:  "6946cd9f54871e722fa668c1f12368e6840d7736b03daee40c31d3009fcc0509"
    sha256                               arm64_ventura: "78cd45cc017b805506b6b8387d1b8baaafd1afe2f0e5e47bce1d82090f76a8e2"
    sha256                               sonoma:        "235f61c4ad505b8cec654b93ea4d47023342ec0ab48c07ed3a57d8f495829d22"
    sha256                               ventura:       "008cbb21ddda61a052a870f8fc675232550aa5d348c14609af046b36120800b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49f8625cee9e132e277fb811705298f8bb0abab58f753b85f76cce4013374a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22abc723b861ac76d1e813dd2b81b8a88e64a5561b1c316fb35be22e625e325d"
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