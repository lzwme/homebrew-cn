class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.2.1.tgz"
  sha256 "8de0f2e151613c60616a99dce8e3d21d0c2d57f30c2ec57ec1c071effe49e359"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "01165f1afcbfd5ec4b1bb6013dae215f5168960d1b9ce32c38859b09abde3d6b"
    sha256                               arm64_sonoma:  "9696cbc15f56be8bfd1a421ad1e0dc38d0b8606aaa0b3b374023d8e1219d45fb"
    sha256                               arm64_ventura: "e810cd75ab7c08f28bbe2b8c458737605cf613d6a0488ab0365e256197aa74d1"
    sha256                               sonoma:        "a5a433abd234ef9f5be3929fbed2c8aeb964f533480b3cf9d6c63e570b7a143c"
    sha256                               ventura:       "bfe6d3e68a0b3c4fb984c1d1a3495b38e57cce73c2ade2c251bcc67435c2f2dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9163004e37d0f3300e4eb6d96ec02b4f6a90a245d431e3b11ca6d5eddb41284d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ece6a045e751cb403d859db982059df917cb3de69c64a692d24220cb131dc8"
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