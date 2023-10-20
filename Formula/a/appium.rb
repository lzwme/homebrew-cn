require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.2.1.tgz"
  sha256 "95282f82c8918797ea0ad97f756f1282147d4da0e1f8728b7d56828dae99909c"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "215095345e53fbafdf4e26cac7e34f02f5927f5fcca02002f61bf02e74de665f"
    sha256                               arm64_ventura:  "c0c6827178a078b813784e30fd04021cd31d40580c5728f89a15d95c67a3196a"
    sha256                               arm64_monterey: "542aeb2d6d403f2d7d98f75585095790f4442d02c52414417321cd946db622b2"
    sha256                               sonoma:         "e570b8f50fd481ea46cab8057f7e32fed81618d7ba0c30d1b8888fbbc92b8d97"
    sha256                               ventura:        "e03bfcc7eac8d833b6b003fc3cb0af42fcefcdc50937131d808e9e289d63f555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00583005de0a9be5a56d893b7040cf864208763da4855c3390d1169ab83b3aa"
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