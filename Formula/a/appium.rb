require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.4.1.tgz"
  sha256 "c573a8782a800aeba4fdda24ce732c62845b8856e5a7307fd165c358e1771710"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4eaa5a9fe75ec43f9bc7e809ebeae06bb1f157c563f003bdf718d9e45444ad11"
    sha256 cellar: :any,                 arm64_ventura:  "4eaa5a9fe75ec43f9bc7e809ebeae06bb1f157c563f003bdf718d9e45444ad11"
    sha256 cellar: :any,                 arm64_monterey: "4eaa5a9fe75ec43f9bc7e809ebeae06bb1f157c563f003bdf718d9e45444ad11"
    sha256 cellar: :any,                 sonoma:         "1b0cb9ab50f4fde01db09262cab923d2306362b2e5ebd6df4bb03cc05ec975c9"
    sha256 cellar: :any,                 ventura:        "1b0cb9ab50f4fde01db09262cab923d2306362b2e5ebd6df4bb03cc05ec975c9"
    sha256 cellar: :any,                 monterey:       "1b0cb9ab50f4fde01db09262cab923d2306362b2e5ebd6df4bb03cc05ec975c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804320fdd5265c8cf9cf3dd1eac96027ba6b39d72e6831a9831af014429ceb26"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    if OS.linux?
      node_modules = libexec"libnode_modulesappiumnode_modules"
      (node_modules"@imgsharp-libvips-linuxmusl-x64liblibvips-cpp.so.42").unlink
      (node_modules"@imgsharp-linuxmusl-x64libsharp-linuxmusl-x64.node").unlink
    end

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  service do
    run opt_bin"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var"logappium-error.log"
    log_path var"logappium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}appium --version")
  end
end