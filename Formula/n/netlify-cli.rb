class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.12.3.tgz"
  sha256 "d78d8a239d24dc9f2cb9e3065824bec9e5e7e4e01e53bd373f9a3a572fe33afb"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f4df9fdf0c85e010015df7751fba5d8586462a0a3a753f1a96d315400737abdb"
    sha256                               arm64_sequoia: "b98f212f0113e124b5248f460932fd23279bcf2f54e1110b669f4a8e125aabcc"
    sha256                               arm64_sonoma:  "3127db2e6c98b0c72925ad00ec93bccbc0cb5e6a885f92d692d9381cfadf009c"
    sha256                               sonoma:        "db3eafa28a8695f56a953f87b599d6c56a15bfecf19eae0eaf8f9458d7e8f494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ca4c623fc456e94a54db02dbb81cd0aec54462e051ad55facd00a0e16e8462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5070f192663dfb2fe3ae2e7fd44c7288b394435ad480f7c2db857de7aedcecd5"
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