require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.11.2.tgz"
  sha256 "18629149331ab369dec4a5ce84da91d54be78ed2dfe7205138785c155a7020e7"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6c865da6b3e20f1824100550abd39adb4d45028e471421e0c50d6406abc9e16f"
    sha256 cellar: :any,                 arm64_ventura:  "6c865da6b3e20f1824100550abd39adb4d45028e471421e0c50d6406abc9e16f"
    sha256 cellar: :any,                 arm64_monterey: "6c865da6b3e20f1824100550abd39adb4d45028e471421e0c50d6406abc9e16f"
    sha256 cellar: :any,                 sonoma:         "c2ec6078122e767d139391e4e95e20ca1aa8cd4ced6b2bf0bd2a39ebf46ad44b"
    sha256 cellar: :any,                 ventura:        "c2ec6078122e767d139391e4e95e20ca1aa8cd4ced6b2bf0bd2a39ebf46ad44b"
    sha256 cellar: :any,                 monterey:       "c2ec6078122e767d139391e4e95e20ca1aa8cd4ced6b2bf0bd2a39ebf46ad44b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4faa09090377833f7f1f53cbecdc721a78fa1d560f2adc3b30cae05fe7ed53"
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