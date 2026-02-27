class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-24.0.1.tgz"
  sha256 "e8f1c4a1c5e471e3ded5cf648c4e87cbf97ac9629158010702538cd6b501d329"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c4126d82ce321e22554b2dbdc610f865b5fb651be9aeb32b67247b6a7ec86bd3"
    sha256                               arm64_sequoia: "335320ce6706720a3629a71b2b7be99993da61141b08aaa16944f065fcbdd7db"
    sha256                               arm64_sonoma:  "645ba998fcfef20ca6fa44cde9687ebc96f90b305abb7b1ee1c842b4f4a07469"
    sha256                               sonoma:        "adf0b3e91f288e22fc1f7cbe5f6e9f538474fe2a4462e73de4e50a3dbddd2a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e333d66bc521baa982c5f1c28bfcb4e4875a530dc04ee91175d10e52b1a683b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cffc784420d0029efae49b1aeb3c6ce5c832c9d4753946a6d257974c16da37dd"
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