class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.12.1.tgz"
  sha256 "9694fd321167180417b889fc1d54a0a6c953742d46e059f0094c5295c0b79228"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f43243e99a64f798df3cbc53f30bb8773a3944ba3130aaa0b8f7b6d016df6cb"
    sha256 cellar: :any,                 arm64_sonoma:  "1f43243e99a64f798df3cbc53f30bb8773a3944ba3130aaa0b8f7b6d016df6cb"
    sha256 cellar: :any,                 arm64_ventura: "1f43243e99a64f798df3cbc53f30bb8773a3944ba3130aaa0b8f7b6d016df6cb"
    sha256                               sonoma:        "860fcf90a5efd9346230b0f10de9712553e5f3c47369948ddcce1e94aab64b29"
    sha256                               ventura:       "860fcf90a5efd9346230b0f10de9712553e5f3c47369948ddcce1e94aab64b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4309b925b41eab6f35439ced5d2726fa0dfd281cb5c818f92ff1a62d398bded"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args, "--chromedriver-skip-install"
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