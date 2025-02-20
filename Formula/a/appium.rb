class Appium < Formula
  desc "Automation for Apps"
  homepage "https:appium.io"
  url "https:registry.npmjs.orgappium-appium-2.16.0.tgz"
  sha256 "de0d56e6fa67cb94d249d85561055afd4b7c4d12889c88508f168ad94e544e4f"
  license "Apache-2.0"
  head "https:github.comappiumappium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee71119a96afd506420f275f2065b7af3a7230fd703380040f5584dff63aaa95"
    sha256 cellar: :any,                 arm64_sonoma:  "ee71119a96afd506420f275f2065b7af3a7230fd703380040f5584dff63aaa95"
    sha256 cellar: :any,                 arm64_ventura: "ee71119a96afd506420f275f2065b7af3a7230fd703380040f5584dff63aaa95"
    sha256                               sonoma:        "06ddc1b16d893bd71619e460f64f6f74cbbb80bcd1e0ffbd49847ce787a391cb"
    sha256                               ventura:       "06ddc1b16d893bd71619e460f64f6f74cbbb80bcd1e0ffbd49847ce787a391cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c77666ea48a449dae0a9d94c554ce9983e84087622399e9b7e4fced5c8cd034"
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