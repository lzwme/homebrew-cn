class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.4.0.tgz"
  sha256 "edd0d671bceb4eb725c77c52688f82cf3b0b367c1f5848556425835c07711a31"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "306d82c5af57d2fd22e167f5e5b49731c21d292c59456c886fe8aee15a85f1f1"
    sha256                               arm64_sonoma:  "c4eee6582a3c0fff2106057a29e71646c9858743c8a2b076a992007139f83350"
    sha256                               arm64_ventura: "89d32a0f83e0aad9ea5b7669e24fb4fba302dfe51a276a6588e9eb52a5bbaa9f"
    sha256                               sonoma:        "0bdf7347118b4a4bdd0f0f318bbc79f6f921ac9c772fe6fe503d69c256a58835"
    sha256                               ventura:       "2cc81acad05035dad8d8cd5f2559b7803b910bcd8e42cacfc44e47a98b9ea15c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b849b675059978b3d389184f84879c30fc3b2816cb2a3ff498bb2a27865f553e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c216ca667898069a3cb367391262a52281dc0be0232f9f45b7683217618a800"
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