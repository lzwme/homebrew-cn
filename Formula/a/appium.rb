class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.17.0.tgz"
  sha256 "f9bc6489a365ea775408ad1f9776cc91863b3195f151b72db5c3e68805c02818"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03b3f8151fc06f2e7dbb6043b734f35ba2fd8552b6519978e4d4dcf649611521"
    sha256 cellar: :any,                 arm64_sonoma:  "03b3f8151fc06f2e7dbb6043b734f35ba2fd8552b6519978e4d4dcf649611521"
    sha256 cellar: :any,                 arm64_ventura: "03b3f8151fc06f2e7dbb6043b734f35ba2fd8552b6519978e4d4dcf649611521"
    sha256                               sonoma:        "77d93d51fab33f83fd056ae6f2021bbde921724f45512c4aad4c055d87db709e"
    sha256                               ventura:       "77d93d51fab33f83fd056ae6f2021bbde921724f45512c4aad4c055d87db709e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3046ce5f67ee3779341cea4e1a7e09cb236b26add75969f8439992328eb243"
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