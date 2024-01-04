require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.4.0.tgz"
  sha256 "aa84b6c2ebf8e30fd34cbdbee7afe6e20cfbdb2601460ba69fde0c22db0f8e45"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3500b27fef4944e38e55759d2c765addff0c605a291e6f8e4c3736661528fe65"
    sha256 cellar: :any,                 arm64_ventura:  "3500b27fef4944e38e55759d2c765addff0c605a291e6f8e4c3736661528fe65"
    sha256 cellar: :any,                 arm64_monterey: "3500b27fef4944e38e55759d2c765addff0c605a291e6f8e4c3736661528fe65"
    sha256 cellar: :any,                 sonoma:         "e65b6694e871db9dd0b55d4d7bd656c1dd1851068dbd92141e1e881b0fe202e9"
    sha256 cellar: :any,                 ventura:        "e65b6694e871db9dd0b55d4d7bd656c1dd1851068dbd92141e1e881b0fe202e9"
    sha256 cellar: :any,                 monterey:       "e65b6694e871db9dd0b55d4d7bd656c1dd1851068dbd92141e1e881b0fe202e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d41a68934865b02cd2f43a686a7b3a3ac404beff2442df9ec1fa5cf6446a5bd"
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