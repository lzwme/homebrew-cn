require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.0.0.tgz"
  sha256 "15147867e18d47ed61e605ec4f62bd937bc9d6a43608fc67f0953cd02fb6cd61"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "3d82cfa9363ae2908d711663076d1ad3652f14387c10a539c7f185eb86dd026f"
    sha256                               arm64_monterey: "95423263b2198b70435f80fe27f2e53968cdb616d83542c0783a447cd0b469c8"
    sha256                               arm64_big_sur:  "270e27355c762b8e501d59c8bec4ae793645842233dad51844c505c5205f8bbd"
    sha256                               ventura:        "db7625b436ba92de5cba30a3972b88d9c5daeb5b050ba1ac8e8e6fccc3b522f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7fa6983cd145d3d37c67a21f853972372bb760364f5b01747180aebbb1163f"
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