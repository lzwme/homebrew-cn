class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.13.0.tgz"
  sha256 "957196371293fe9d1b9b950031fb09220ecb2ff022770c634c9fc50b4713c44a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "49e3f18dae5d0b8e6b33a959dfcc49bfc0566407f28c08f551b11b4570dcb1ce"
    sha256                               arm64_sequoia: "98e2d65125ff57ef0652b3b43baa0772319567fc7b5d994846342b4de94f4c76"
    sha256                               arm64_sonoma:  "49f12abb398e417b171e4cf863bd7a77b3dbc6d7cb10c3f999e1642ff936c9f0"
    sha256                               sonoma:        "5a26e39d983e199e977437293c56167c2bf1ceb032df629d79d2f94b4c2c0269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0fd8522e5f48157ef107c71c845e2b1aa687e4c704976c12eb7a20e0c0d92e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca3589a9f1e0408265929e8a0214ea047f502f3178541d7cbcdc0edfd06e850"
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

  # Resource needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.1.0.tgz"
    sha256 "492bca8e813411386e61e488f95b375262aa8f262e6e8b20d162e26bdf025f16"
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
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end