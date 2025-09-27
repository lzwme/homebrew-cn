class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.8.0.tgz"
  sha256 "a640215fea0bcd61c7dc4a411d2f882daa020c0e180885e6b02394e958c6d48b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "335583ce1cad4ad1743133f84a53d94a0755099901d120bbf129530cf67d0067"
    sha256                               arm64_sequoia: "609312fc9ddbe6ff98674dd6964ac670d1abe32d7b2f2b29d7bc8339abd5ff8d"
    sha256                               arm64_sonoma:  "2b0db7e2f84743f331677eaf7243eccc2e107c6808231e4f88705b217b97f40e"
    sha256                               sonoma:        "cced8bf18d906137fa8679d69c377056c438645a406f0d15a9f728dda2109c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8e4330bd05ec9ea6059eac548724e306d8d6239b346135299a3e07e9710641b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfc331f36da74674fc005139fe5a92ed5661b2bc0e9fd1704c7eebec4ed8d0c"
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