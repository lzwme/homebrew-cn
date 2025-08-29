class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.4.2.tgz"
  sha256 "a9ef61906c2f5c4059c5376e83f15da90d09c54989b54060e8eb43e5bb58cf50"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "8c740172fd511c1b05b4c336171883ae3372d77a6708c30dc061ad3cb1faa92a"
    sha256                               arm64_sonoma:  "89566481ef5ad748d518e45cf86154e02e28ab0b759f7bf03a0d8a38bef92747"
    sha256                               arm64_ventura: "34166332bc12e78bddebdd79e0dcf2d487f337b6459b1aebbf45b8aa1ca36e9a"
    sha256                               sonoma:        "63a68c406d7ca7e92682af7be7c181f4481d7b3065384660d2000b9cb491d824"
    sha256                               ventura:       "cd1cc661d1806aa9b2a6652f73832c2eb15e2b804077589d1d5e509e922121a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc2ff4ab79bf7cc7f1e9245976f58b88c65aea24bd5979c829e00beca194871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e276310a292fbd95926ba4706c74c83c54ac899b550979210eb663f20bb48067"
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