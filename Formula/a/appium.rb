class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.13.0.tgz"
  sha256 "23f8a4dfb5b29a572a6b9362e9bed099a8b3367eadce326300ba803ec9cdacf8"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "195c65b03f7974985377eda92bd48a0d6a4a602e2fa3c832faf9189d78b032af"
    sha256 cellar: :any,                 arm64_sonoma:  "195c65b03f7974985377eda92bd48a0d6a4a602e2fa3c832faf9189d78b032af"
    sha256 cellar: :any,                 arm64_ventura: "195c65b03f7974985377eda92bd48a0d6a4a602e2fa3c832faf9189d78b032af"
    sha256                               sonoma:        "eaf5cb13fe74fe77f0c012ca35b8f1eaa41c0824f31545499b3caa6d1b03c318"
    sha256                               ventura:       "eaf5cb13fe74fe77f0c012ca35b8f1eaa41c0824f31545499b3caa6d1b03c318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408ddf73030265a2f26c60043453156a7d7ad6c634f21f1e83503cb13fed9883"
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