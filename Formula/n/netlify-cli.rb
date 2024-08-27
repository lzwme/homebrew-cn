class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.34.3.tgz"
  sha256 "6a72dd81c1ad6c05af9c25b22b98226160dfecad9ab114119f239b20fae3e2d1"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "f8563168b48fae7895b59036267885ac0f4bef9c22747fb562d54f1ed2cd44de"
    sha256                               arm64_ventura:  "8d82bda0212abde19519050f8ca416a18d85481b4695603e3ac44d2a178eb412"
    sha256                               arm64_monterey: "d875bd4cf2d6a1318fc85aba548a06fdf0177545e9a0062f823940716998a183"
    sha256                               sonoma:         "fa7d2373c22448b3a8d1c89ed0f0f28bb970255a0698616ae04e13e95c114f93"
    sha256                               ventura:        "945139689288150b874e9a80f7bb969189291600a6532d541c9daf0fdb209541"
    sha256                               monterey:       "42576e30c3d43ec171864a4550e529bb45ad0ffebe10580e24dfbe92c913bad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c29e2fce413e5d7f6776185e7f5d7b3b2b8ed8458c4390ed0263f682df5366"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs``bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end