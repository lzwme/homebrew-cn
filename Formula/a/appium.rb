class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.1.0.tgz"
  sha256 "7b99c3b9369c1153b28f65924b3becc54473f5e8e321cfd8bfdcba0393d688af"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f59248aaae23303ec920a2150cdf73287b66d5d1600653d5ef5bf4798c26758"
    sha256 cellar: :any,                 arm64_sequoia: "c6038dc285224ca95469c4be6300dd1b8b56b32c1fc40c2961090bbb8593e84a"
    sha256 cellar: :any,                 arm64_sonoma:  "c6038dc285224ca95469c4be6300dd1b8b56b32c1fc40c2961090bbb8593e84a"
    sha256 cellar: :any,                 sonoma:        "a9987eab2dc3d8c97f103c68101cc4ab4c54840e363d770b77fd46ff71c06245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020a4e007df5d7ae1398dc34e737bc7b0414a07c1ee1c008694dc9c0ba230e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72da5540d9a2e4214bb00d1d3e145a511eb931bc101e50547d948cf98c1a63d1"
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