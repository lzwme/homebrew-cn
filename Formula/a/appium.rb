require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.2.3.tgz"
  sha256 "b2500aef1507b3b05dad2ed45cf890d3d56d6cd7a062a471787c1cc046d51f0c"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "246b880e6136ade3c1162e9a316a234e1c9a9c83989100f4635ba1cb3ccecc09"
    sha256                               arm64_ventura:  "140af60d8545ba344fe6e70b3e24fb6361bd26a5190e0ae3859e02cfd6d0a3fc"
    sha256                               arm64_monterey: "07a4af889fa817840a717cc0ce1bc505f655b8db40d93214f548e8875390fabf"
    sha256                               sonoma:         "15d17c17595b4144f493d0f3f211a4c88da29edc35fd89891fca4d921af7406a"
    sha256                               ventura:        "001762b19b94176e3cedcaedbfe54476ad97f8ede1a93b7e9fbfaa2a29e6c1c3"
    sha256                               monterey:       "7a4f9504d78df565293cf9f51b411d40d372dbdd3f206893d799ec48aa864b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce8847902049c88788e2c042a9351c6c426d04fe9bdf7329b365881967a4785"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete obsolete module appium-ios-driver, which installs universal binaries
    rm_rf libexec/"lib/node_modules/appium/node_modules/appium-ios-driver"

    # Replace universal binaries with native slices
    deuniversalize_machos
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