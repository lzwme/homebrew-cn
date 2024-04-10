require "languagenode"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.5.2.tgz"
  sha256 "d996714d39440a1cb15b98a266653bc42341643fa1acd9f9a4390e3a7fec1d0b"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10a889932ad50c1c18891a5d25a6ccde41cdb23f6de5d9111575058c451c1c9c"
    sha256 cellar: :any,                 arm64_ventura:  "10a889932ad50c1c18891a5d25a6ccde41cdb23f6de5d9111575058c451c1c9c"
    sha256 cellar: :any,                 arm64_monterey: "10a889932ad50c1c18891a5d25a6ccde41cdb23f6de5d9111575058c451c1c9c"
    sha256 cellar: :any,                 sonoma:         "7b9aa5337c5b372a2fd803bfed87a13d3cb1324be019b9f8f1076e374d840522"
    sha256 cellar: :any,                 ventura:        "7b9aa5337c5b372a2fd803bfed87a13d3cb1324be019b9f8f1076e374d840522"
    sha256 cellar: :any,                 monterey:       "7b9aa5337c5b372a2fd803bfed87a13d3cb1324be019b9f8f1076e374d840522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600c34aa28b5a21bb30eaaa8fbc7eff1b06a7c064273869c223d376a9b0cbad1"
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