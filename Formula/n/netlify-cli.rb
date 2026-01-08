class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.13.2.tgz"
  sha256 "15be1fab149d43916c2d05b51d72ccb3f99fd17dfb90fd4ec79e01c7b311543d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ef0a7e8221fdfe1d090197ebf78685dcfdedc0abf90269d5c36a6cca2382dace"
    sha256                               arm64_sequoia: "f51f1944803ae2a134a0019383f861ccb6537dce41aedff3b70a0300b953ba3f"
    sha256                               arm64_sonoma:  "981c525416caea313fd48906d02b4065ed150fa11f5ab2b98cd28c948863a0e1"
    sha256                               sonoma:        "8ff90384ab5d024466df8fd50db56963b3c0dc18f8a22040f07ad603d483a167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82cccb0d2ff98e8315539ae6448729c5fa5763783b0c519103c97bf578e8b074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c126ee3adb5ca372a1fdba61a0a942cfeb4052a15e400734452b4910d6ca48"
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