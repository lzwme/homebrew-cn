class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.1.0.tgz"
  sha256 "7b99c3b9369c1153b28f65924b3becc54473f5e8e321cfd8bfdcba0393d688af"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "76af0c1d7698c140ecec7920a5e9d41ccad5b66b88c7a9fe6c81588c04e1391e"
    sha256                               arm64_sequoia: "e05b4803a82b495523703ec4ae2d4ef2705fef049c4241851ad7939291d1d9e3"
    sha256                               arm64_sonoma:  "3be5942e69f3ad3524a7911a461793989250541e78624610095959b433ce11e6"
    sha256                               sonoma:        "560e26822807d72f129f49508fef55b505c345b8ea5cbb80f21b24f211989bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce681cca5fd2d4338189539a6b0b5aba53a5db9ca627d1b2ea2f3c8835440cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266f9a3b043f1c890115a541847b4cbf71dba993f8ca614422140ea1588c5429"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.0.0.tgz"
    sha256 "bbe606e43a53869933de6129c5158e9b67e43952bc769986bcd877070e85fd1c"
  end

  def install
    ENV["APPIUM_SKIP_CHROMEDRIVER_INSTALL"] = "1"
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/appium/node_modules/@img/sharp-*"))
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