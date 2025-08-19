class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.0.0.tgz"
  sha256 "88c3d53813211f676b59418678bde23375bc33bba79cb6569138b47474d09f39"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6c03b079472dfff74cb587160a1807e7f8505f733b5f085ec485f26f10f40b9"
    sha256 cellar: :any,                 arm64_sonoma:  "c6c03b079472dfff74cb587160a1807e7f8505f733b5f085ec485f26f10f40b9"
    sha256 cellar: :any,                 arm64_ventura: "c6c03b079472dfff74cb587160a1807e7f8505f733b5f085ec485f26f10f40b9"
    sha256 cellar: :any,                 sonoma:        "7260bfb1d64e0029204211a633803a27a2c32e7c8d87570e746bcbfaa2ddcaaf"
    sha256 cellar: :any,                 ventura:       "7260bfb1d64e0029204211a633803a27a2c32e7c8d87570e746bcbfaa2ddcaaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e83a8fb5ef40e265f32dc5434a56a76c0f2a18e6324286ae0ed8f59b38dab6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddd5c5d9b430049f63d4ba992a6f5c1d1f53a277c79cdd5d47b881c9e38f8ab"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *std_npm_args, "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium server --show-build-info")
    assert_match version.to_s, JSON.parse(output)["version"]

    output = shell_output("#{bin}/appium driver list 2>&1")
    assert_match "uiautomator2", output

    output = shell_output("#{bin}/appium plugin list 2>&1")
    assert_match "images", output

    assert_match version.to_s, shell_output("#{bin}/appium --version")
  end
end