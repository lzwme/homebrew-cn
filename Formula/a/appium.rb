class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.16.2.tgz"
  sha256 "4a2b2c8640af694489a90c3fe3df9119345a7a1fc66a37cb975bac36f46a48a4"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53fb0d1d19080b67ba4a93d23ce0f51df8a83c86beabbf9532b4f619a0855e25"
    sha256 cellar: :any,                 arm64_sonoma:  "53fb0d1d19080b67ba4a93d23ce0f51df8a83c86beabbf9532b4f619a0855e25"
    sha256 cellar: :any,                 arm64_ventura: "53fb0d1d19080b67ba4a93d23ce0f51df8a83c86beabbf9532b4f619a0855e25"
    sha256                               sonoma:        "cf5349bb6557cd1d9c524593eb222588810b5eb74c2e5089bc06ffabf19c4222"
    sha256                               ventura:       "cf5349bb6557cd1d9c524593eb222588810b5eb74c2e5089bc06ffabf19c4222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07959a981f3191dffdcf982adcf4d2e4cfd8de144ae5915be824869e89459fea"
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