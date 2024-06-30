require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.11.1.tgz"
  sha256 "7a7f33d2ee805398dd53d89aff1451ee1f97641078c863b3258df56704dd844a"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2502470c73a3ae37df6895e063b0e1cd5cea848bb5bfb5947a33751bbdaa5abb"
    sha256 cellar: :any,                 arm64_ventura:  "2502470c73a3ae37df6895e063b0e1cd5cea848bb5bfb5947a33751bbdaa5abb"
    sha256 cellar: :any,                 arm64_monterey: "2502470c73a3ae37df6895e063b0e1cd5cea848bb5bfb5947a33751bbdaa5abb"
    sha256 cellar: :any,                 sonoma:         "169a6c227eb79756d4bf4105aa94958ef502db9d7b5ded0792bcd2650dcf567f"
    sha256 cellar: :any,                 ventura:        "169a6c227eb79756d4bf4105aa94958ef502db9d7b5ded0792bcd2650dcf567f"
    sha256 cellar: :any,                 monterey:       "169a6c227eb79756d4bf4105aa94958ef502db9d7b5ded0792bcd2650dcf567f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb889518d8d61fc36aad762a18b49ecaccfcee02cb32c730faa96393117c8a6d"
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