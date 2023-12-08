require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.16.1.tgz"
  sha256 "8428bab08b78dc6a1c00aabd93fb59e12aa7c491ac6498de7ecc5447af247cb4"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "13865faf809a1ded804f673b8e52df6d6235f2b36314b40ff6c4144711dc66bd"
    sha256                               arm64_ventura:  "d7c97fa91e4f90ef229482cc2a2bb7f76f0ca06359824636e61232521f6cbb90"
    sha256                               arm64_monterey: "f4d15ba43bc897e7737377a5d2a0be0405d8e170eaeb41cfa369940edc8641d4"
    sha256                               sonoma:         "f3d911826c6091b19b9831e56c5dd82719cf63854b2cb76da28ef9e7935d392b"
    sha256                               ventura:        "ef216b65daf91abd2c4f91c62ee28cb5c0f54c3529c5d543cd72a8013e839cef"
    sha256                               monterey:       "11358320595501d90f6a042163e91bb0ab0d966f8a4a7d02775acef1d5d17310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7524aa653fdc07c2e5f33c1c95a4bb07c71c29cd9a06d5f4e43ceed291d5088"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@hyperjumptech/monika/node_modules"
    node_modules.glob("nice-napi/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

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