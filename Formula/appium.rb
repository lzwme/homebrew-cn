require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-2.0.1.tgz"
  sha256 "ae14a94002e839e8b37fc3bd37149d7809ff5387d998e97a15afb5e607332652"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "56774cfe6b3b382cfe8cdef565ee0098723f1ae58b1a729dac89399a3370b085"
    sha256                               arm64_monterey: "dc95f83f2e5250db566093afa36e24770671b255bca4c0dda783ea7b704f8f16"
    sha256                               arm64_big_sur:  "384ca65ab978a113f4628ae6f20a37fe091268fe799b7b8f6d0673333a509c70"
    sha256                               ventura:        "c72a5007cf9285245b012038c69f2c4cf26fb47da6f8fe991bfb8b9035d26ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c210a2651d86b00f7cba7ead779b6da3f59aad6b6176369c5fb092a5b14c28bf"
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