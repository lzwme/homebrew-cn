class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.11.0.tgz"
  sha256 "d5d100b88c12f4fbc1bc0e68f152d06aa062b632b4e7d348bfde2b7294c1e756"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1aa5df1a0bbad2602b466a6a71c8a2d9b59cad5d75866cc600637710172e8bad"
    sha256                               arm64_sequoia: "4e0563e930b1aac1d0d274482ea64f362d3dbf317a41f286a0f35db66f7c04a9"
    sha256                               arm64_sonoma:  "804bbbb716e6cd844ede95e01272177726ae2d2da31434f347d3099d27b83d77"
    sha256                               sonoma:        "14b83ad25782224c89e5cbf09efd0c72abc7583b7ba68c4777a0f6daf3599e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e869202b37a297aab7e5eaa53e1750eefedc12ba0f303cbd75d702a7f0a6beb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a43b593e6248d157c3f7f7ba95499a834bc33bf1bb4bf14d7fb43f3dcbd0f59"
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
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
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