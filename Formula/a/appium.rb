class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-3.0.1.tgz"
  sha256 "6c2e667da0c624a3ae9ed980b5411604384317ac2e1734911f322acad8f043af"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e44dba22af0caf0a4dfc509fce87e554ce58ce26e9de67f22acb9f01bad4a2e1"
    sha256 cellar: :any,                 arm64_sonoma:  "e44dba22af0caf0a4dfc509fce87e554ce58ce26e9de67f22acb9f01bad4a2e1"
    sha256 cellar: :any,                 arm64_ventura: "e44dba22af0caf0a4dfc509fce87e554ce58ce26e9de67f22acb9f01bad4a2e1"
    sha256 cellar: :any,                 sonoma:        "e129958889df92a0d4c45b84143fbba96c583902768ea4d01cfb83d30f0b05da"
    sha256 cellar: :any,                 ventura:       "e129958889df92a0d4c45b84143fbba96c583902768ea4d01cfb83d30f0b05da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ae80af6ac99385d4915feee38a68ebeccc74e52fb9e77f9c730bb58a36cd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544979a67c964971614abf6a9b87b2e0ad6444886fa2ede125b22f811acdb699"
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