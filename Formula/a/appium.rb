class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.11.4.tgz"
  sha256 "ba98484b5271905f65b522a97b26d1d694c226345764bab479b60e64b5c91e7a"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8d279af601f9bcfbc9a820283e9d8ec6174d41963abf674d8fbbc2afeb34b2a9"
    sha256 cellar: :any,                 arm64_sonoma:  "8d279af601f9bcfbc9a820283e9d8ec6174d41963abf674d8fbbc2afeb34b2a9"
    sha256 cellar: :any,                 arm64_ventura: "8d279af601f9bcfbc9a820283e9d8ec6174d41963abf674d8fbbc2afeb34b2a9"
    sha256                               sonoma:        "135649b1d52575f73675618d0251ff2795f6143fd741aab9947a76c13d168f3f"
    sha256                               ventura:       "135649b1d52575f73675618d0251ff2795f6143fd741aab9947a76c13d168f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3311937d73f1ef5533356feddd47228e499c9941637992d7b3683d56a271c4c"
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