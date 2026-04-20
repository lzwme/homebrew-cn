class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-25.0.1.tgz"
  sha256 "dbc16ff033da843d38e66bb6fd133dfe13f6f880de632e4938c91c332c08e849"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f5e0ae5ca9d89ea78e281f2569d4c1b29a20a1e2c7adfd7e7479a15f816abb0d"
    sha256                               arm64_sequoia: "b6eeae0bad06e64abd3cf725e4cc4ce16db5f4dcb494a4d6c8b35877509cdd20"
    sha256                               arm64_sonoma:  "cd9d8a0cfbe0089d21419caa3aea414c61ac7d528b20d7a4738be1b30ecf41ad"
    sha256                               sonoma:        "f54f86e919b8199cd3a04c7a3b3605eddd93bd923900e9020be29351eab17064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9435d0f7b64cb58d2990784210842f45ef99967d3d3613413a672cc8f1334c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1929964e74f0c310d4337db69bb77f8e1a00a0d597de6fe48d05b1f55550e1b6"
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
    rm_r(clipboardy_fallbacks_dir, force: true) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
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