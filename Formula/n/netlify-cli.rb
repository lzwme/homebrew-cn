class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-24.0.0.tgz"
  sha256 "be77667484a0d7ead83966376221b145fe1cc0f4545defc6b0edcef90eea7654"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "91c11ab65f001bf5820ea793e6bcb353fdbf28dbb8178b556ed883d2a5f464db"
    sha256                               arm64_sequoia: "f87c6770053c3e794071ebfafd41d7887b9d2c2682af831b2edcd411bb4c0945"
    sha256                               arm64_sonoma:  "edb6cc8f9ec5b6d8f9ebc5d63cd8e4ca2bff967d29289333cb223807dd6d7dad"
    sha256                               sonoma:        "cc4264c34139b59373c0f5b7d8acf3cbe43d4e6eb6de864503f8b6ef4b8f35b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a90c317c2eeaae06681badd1bc6e14145def216aac446af82807fcdffac0226f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536ad1a062c3679fb5ec7c10b8fd2861c852899ce9cb0e5b349ba7a943504350"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
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