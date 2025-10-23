class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.9.3.tgz"
  sha256 "75d9b536864fb99e2bc9935aee073c007aa4bde9800b10ea13e2b53adba97c37"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "dc1bf97ae7eae08b7b53db1b1a4ef5079637cfc61b790c28ef1fa6d21ae09023"
    sha256                               arm64_sequoia: "46be800b8989c68d879151ee00399528bbdd7a81ee634ac5b2c6e4e1163986a9"
    sha256                               arm64_sonoma:  "d5657c3def32dc8aeddc9215063e900bb6a51eeb940a18a2708abcf3e20df55c"
    sha256                               sonoma:        "3b5e64fa6786b3fc84b38d7be684bc4d2cf3f22010ae541ebeb2d9373ff45190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad61305a0d31e94e98c732c9311424dfb9184513fac7ccfef2216b1546e6fba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584cfc718495d4faaf6fe3c58ebe601e6b85664538f7954694e813679222f09a"
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