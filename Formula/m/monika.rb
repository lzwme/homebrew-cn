require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.15.8.tgz"
  sha256 "1e573659b3dad17c14800e777e4d2056d5365c2773885326febfb18ac589a48b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f94cbc45be89c5e1580dd74c194553aafd86663ddbaa899a66342ad14ecf59a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccc0c21f1a2497b9fb032202273df45ccd75b4304bf234e0cf2449c8377cb58c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d8732171211dd46b40cf6465ff080c559b27c6ee52439ac6ec0eb82c4b8319b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "854663ddbc99fae9f98480a85e324521e7feca546e763a57af235240e52a9923"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e3fc9c77c08f6381e2af584dbb6c41253df4a4dd6b153990db6c5f666195804"
    sha256 cellar: :any_skip_relocation, ventura:        "c1b52bed0380c9d3259cb069afbf71b9d065a09e3598489fda87cf26abc59856"
    sha256 cellar: :any_skip_relocation, monterey:       "e73aa6c8117c6ed805739dde4ba05f796ec39646ee3b72fcdfacaa1dff9572cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac5a48d6f345e84fdfbbb5433598f8801d5129131b3bd5d957017d6dc9a0313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c76e623dcc382c40b52198cc35b2237bb68f69cf4cfad2aba5a66719ff996b2"
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