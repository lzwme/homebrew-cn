class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.14.1.tgz"
  sha256 "e7d8404a30b0980109b1739f8f09f071923af457613b27c9288248f8f812457d"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a91c56cf65c1c1771205e3de3bbd7eef2ef13f6df6d32a6f485cf8d7010c694"
    sha256 cellar: :any,                 arm64_sonoma:  "0a91c56cf65c1c1771205e3de3bbd7eef2ef13f6df6d32a6f485cf8d7010c694"
    sha256 cellar: :any,                 arm64_ventura: "0a91c56cf65c1c1771205e3de3bbd7eef2ef13f6df6d32a6f485cf8d7010c694"
    sha256                               sonoma:        "0155f886dcccd43a5760ec1f9d1787ea76aacea1f4885847c8d8586b89513e60"
    sha256                               ventura:       "0155f886dcccd43a5760ec1f9d1787ea76aacea1f4885847c8d8586b89513e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88af9c99792ba6256b5dd8070c22e13ea42bed484735ed603261e2b9bc9adfd8"
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