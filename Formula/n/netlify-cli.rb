class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-27.0.3.tgz"
  sha256 "f7356c433d4a3bc8d5828a63b7740f462bd0a3b01819be388872cd3bb7b29938"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "d568ce58954e59c4469271c9db0a3352fa47591d822e2c0a017d8e4b667d0233"
    sha256               arm64_sequoia: "cd4587f33141f99e32a1ac7c7966ce5d0ece25f04719ff0d8df15d85477cf484"
    sha256               arm64_sonoma:  "6747e2fff59fbb9c84dd01554599a71c2eca826f0c9e5a5705addf19cd6ba22f"
    sha256               sonoma:        "daeaa7e1e63c7b38b224c470cb7bea4b12d4d10d1cd47e5d1a6f110fbde0af29"
    sha256 cellar: :any, arm64_linux:   "a6306724ef70de01c028ced8e37217f7d665b716a1b2b83ea6ecbe9c85f9dffa"
    sha256 cellar: :any, x86_64_linux:  "2e2ec1cb6b79cbd55fda5bc9acc9a10de994caba55a85c22b1c30bc8d7b36732"
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
    depends_on "xsel"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.1.tgz"
    sha256 "9091c2a5e57dae6ae5a0ca9c42d6127586bed4168cc1a342c95b64e61efd60af"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir, force: true) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (formula_opt_bin("xsel")/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end