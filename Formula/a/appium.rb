class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.2.1.tgz"
  sha256 "4c08aa76150c006aed1a9db03added23b9ce733c30fb1f263fb02244fd208fb0"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "d9f6e37e13cf0cd478534e0eb67b0c263c2e3faf4aec8c2b819c3d812ea3f386"
    sha256                               arm64_sequoia: "7e23022522afdc19e6f8c719a34611b560bac6203fc4fb8d06b8295d5c833e4f"
    sha256                               arm64_sonoma:  "6173d968b05b059515b1e930f7bf84cc17204728f23db5545122d7b0baacfb1d"
    sha256                               sonoma:        "b59abfeab137af536d676b544cbd5dc9a4ecb020e1b5bb36d9bb3cdd6b850664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ce933de6e17f39f75c6d18dc07154fcb44a1e518d01bd5ee7e8902ec44b42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29170269791458dd4636fb3c12b3abc64035d275cd96a76c477a5db40b6b402e"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.1.0.tgz"
    sha256 "492bca8e813411386e61e488f95b375262aa8f262e6e8b20d162e26bdf025f16"
  end

  def install
    ENV["APPIUM_SKIP_CHROMEDRIVER_INSTALL"] = "1"
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/appium/node_modules/@img/sharp-*"))
    rm_r(libexec.glob("lib/node_modules/appium/node_modules/bare-{fs,os,url}/prebuilds/*"))
  end

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/appium/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end