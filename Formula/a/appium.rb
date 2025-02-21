class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.16.1.tgz"
  sha256 "a84da12d5f22bcc7a9e652e213bbe5a775eff8490752a800e3fa941b9b3a32b6"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4bf2ed0afd64e8146e8fea15bf9eed10c8a7c8070c54fbf81d99d752f7f3afef"
    sha256 cellar: :any,                 arm64_sonoma:  "4bf2ed0afd64e8146e8fea15bf9eed10c8a7c8070c54fbf81d99d752f7f3afef"
    sha256 cellar: :any,                 arm64_ventura: "4bf2ed0afd64e8146e8fea15bf9eed10c8a7c8070c54fbf81d99d752f7f3afef"
    sha256                               sonoma:        "61e77d565c9de39eab53c0b304370bb1ad817aadf2c367374fdd2b998d1f0b4f"
    sha256                               ventura:       "61e77d565c9de39eab53c0b304370bb1ad817aadf2c367374fdd2b998d1f0b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7052ca25285fb4a4ab789236365a77e47f2a76f75bc39309e5b5cddc05c0601d"
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