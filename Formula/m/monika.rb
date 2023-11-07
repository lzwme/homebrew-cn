require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.11.tgz"
  sha256 "323b444e77f95ec9599a562509c96c8142296bb0efffd31a9bf2b9e97f45009d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22f26025a62280af7e00a8ec6cebcf18011e9355fdd10143bb06a3f8f0297a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea244f9422fb8e636dc8cf860b7f0f04c94ac724d441a18bbe9ad9458ea7cbb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "715741a2d32abb8ca6fe3aa7490f39c4b432ca30f9f9c3cf5477cfa647abab3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdf58f02dc3458f623822c8243f967463ec321ec1bbbe92c982b6301760b591a"
    sha256 cellar: :any_skip_relocation, ventura:        "b3367401fc33ca550c96378c51a3f80ffb0fa5f896a9f1434e8756c32ee01269"
    sha256 cellar: :any_skip_relocation, monterey:       "477182b89991958f453d751e50d370bb42baa8fcb9431711b50304c0504f58b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa53e5d2625f52650992c1518033013687898f12612bdea107704051eb445994"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    (testpath/"config.yml").write <<~EOS
      notifications:
        - id: 5b3052ed-4d92-4f5d-a949-072b3ebb2497
          type: desktop
      probes:
        - id: 696a3f57-a674-44b5-8125-a62bd2709ac5
          name: 'test brew.sh'
          requests:
            - url: https://brew.sh
              body: {}
              timeout: 10000
    EOS

    monika_stdout = (testpath/"monika.log")
    fork do
      $stdout.reopen(monika_stdout)
      exec bin/"monika", "-r", "1", "-c", testpath/"config.yml"
    end
    sleep 10

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end