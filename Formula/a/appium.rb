require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.11.0.tgz"
  sha256 "80db90a6a80f1bd6c29c81d4a2d74eaec23cef262a5849da544aed1af0e1937b"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fc50e838f49f8bdaccadeea7ca6ba83e70ef800ec049d2762868f217d8e501c"
    sha256 cellar: :any,                 arm64_ventura:  "8fc50e838f49f8bdaccadeea7ca6ba83e70ef800ec049d2762868f217d8e501c"
    sha256 cellar: :any,                 arm64_monterey: "8fc50e838f49f8bdaccadeea7ca6ba83e70ef800ec049d2762868f217d8e501c"
    sha256 cellar: :any,                 sonoma:         "7dee7a8ecac4f638645923db7ebee6d39f0c1d52817aa3617318bd0ed0641842"
    sha256 cellar: :any,                 ventura:        "7dee7a8ecac4f638645923db7ebee6d39f0c1d52817aa3617318bd0ed0641842"
    sha256 cellar: :any,                 monterey:       "7dee7a8ecac4f638645923db7ebee6d39f0c1d52817aa3617318bd0ed0641842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cd1f9fd754f48f092f12e379d6c20d90386060e3e3fa948eb167d108b208ce4"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}bin*"]
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