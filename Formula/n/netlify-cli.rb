class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.13.1.tgz"
  sha256 "a38b12a096402413ff94567b7bbc2bf51cae6016abe0f0820c6312236619aa3c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "89ac71e83107657b1d1484af3f59e03b724f4f2784b977e50c83db501ed24f06"
    sha256                               arm64_sequoia: "036d54719def32f90cde72fe1417110b0cb21a728b4748857219d2c563672b6b"
    sha256                               arm64_sonoma:  "d6fdf09bfbab9c0a7b1e9d0e2ee3ae34a99699802ab2d498740baaca5ad1d055"
    sha256                               sonoma:        "86bd86d3b0e4e03f6bc29f980c36a01d764cfa69c5871dda6092659003bb8016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23a316893532ae2f8eb16a5361ec9c511918edbe45889cdb7485a0ffedea9201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2913287ccc69e812ffc41fffe5d413c3c8618e386bd9a51b5430098c2ef265"
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