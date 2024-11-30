class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.12.2.tgz"
  sha256 "0c48a5fc79b36c85af9769813b87ed7c466a6c3de1f2c5b3160c9c22b1858498"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2723ba519d9a57f9017c0d678e90cac18a297dc3f6b3259d4dec2d8a3f503dd"
    sha256 cellar: :any,                 arm64_sonoma:  "a2723ba519d9a57f9017c0d678e90cac18a297dc3f6b3259d4dec2d8a3f503dd"
    sha256 cellar: :any,                 arm64_ventura: "a2723ba519d9a57f9017c0d678e90cac18a297dc3f6b3259d4dec2d8a3f503dd"
    sha256                               sonoma:        "5f311fd24fa3533d328a60aef64a64bda4bfb17fccafb8e9b4715ccfcd0e6e51"
    sha256                               ventura:       "5f311fd24fa3533d328a60aef64a64bda4bfb17fccafb8e9b4715ccfcd0e6e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d177690b8523984bbaa70ee5730f7a0ca134e71cb7aa92e8d29d6302ff12a3b"
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