require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.1.2.tgz"
  sha256 "6087e6186f09f69410d69870b0a2c52e0b573df8c5b849f0dbbbab89162b9c05"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "ecc60b5327a98e47598dc134d9471535f69e11aeeadf7e7308462fc82becb963"
    sha256                               arm64_monterey: "21b7305524b23abefd36035e4684502e89158d5955c7f9a6045dd3a294d4c31d"
    sha256                               arm64_big_sur:  "3c7ed19cb92c1a5c2c5d5deb3f9e45f44db54377df588672ec55f01a0f2492b0"
    sha256                               ventura:        "9eccd2adfd0c9f6a47a9e8f8df4fad5a45ef7bbae682b4029fc9ee383af035b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad0dd8f53d4135c87b641c841df714fe89c685db215c33ba7e3e1e2473bf6d0b"
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
    assert_match version.to_s, shell_output("#{bin}/appium --version")

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end