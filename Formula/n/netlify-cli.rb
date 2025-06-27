class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.1.7.tgz"
  sha256 "f891d403497c11a969564c4f777345b74d173f0c1d6f1cfcb5e4e3c9b8b78029"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "386cdeeb6db161ff014bb69e276a8617e44166c67d7ebb4ea6e23c46e98b1296"
    sha256                               arm64_sonoma:  "3b8631c1e15d9826a684ff3835c9af2b9fbb3a0c5f6a77ae3601fd31b96b7d42"
    sha256                               arm64_ventura: "e0107d847177c7cccea3193d9d6382637e01db29fcd331140cf6846eaf406146"
    sha256                               sonoma:        "28349f11ce57e0cdbeb160a2cddf824371fe3e1f92ef1bd8826a9fc591ff2346"
    sha256                               ventura:       "b19bf06386c3ada404cd5f66bf207951b1b70be6c5a3f97f8596661c8137de9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8677da7f6cde744d93720a45818625bf6901da0c1518cf0f69ea09b3927747b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71b95ba5a95e04094a69c68912277ef92fce9595ef8b9217c290f761dc62b98c"
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