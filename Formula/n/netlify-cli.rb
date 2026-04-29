class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-25.6.1.tgz"
  sha256 "3f0a36b4845a4864ee67ca8f6c29290cb4b320e817f1edd891d5706b4a3b71a3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d0576a99410883682972fb6b6e32b0ec711809914c9b6ecb81725e0af96d67de"
    sha256                               arm64_sequoia: "580f3d6e4c78bf8a5511fe2b07d8ee0b7406d900b6383f7bbe2791573eed19b4"
    sha256                               arm64_sonoma:  "4955cc7c114fd293a17aed618334532f61f20fe95f6fe4fc017a3782d4ca09ea"
    sha256                               sonoma:        "65b788e55e18807d73a58e1008ffffbcdfc2a50c55e2a73f461e0d584e668aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84c97df2d283e49b682a46fba1d0fbb6930d12dee3e2fbe77c48098eec5198c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c66b24fd079d9123785fe80942a5fb1f22108bbb8ba706c522e8cb046770e1"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
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