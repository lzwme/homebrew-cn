require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.16.2.tgz"
  sha256 "c0e5e3df3f1d5591e1763ae40849fcd4db1ef469c7ab7f8af159f4a0a8781f44"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "aff98cb7c7624ef2c2919e3a6fc410f8fd15c5e09b031cc7995f9e540839caa0"
    sha256                               arm64_ventura:  "b94acfb788898a9b69c5d5aa85985e5956635e09a0487529f94b5ec8e0073277"
    sha256                               arm64_monterey: "138dce1df9e51b3bb993f6f45c982968c6002d1ca82057b5a6b6d8a4fd8f17ef"
    sha256                               sonoma:         "39a659487447bce14472e1e441c0a4cda1e1c9bc4f4f18905ceb9e4530a91435"
    sha256                               ventura:        "90877c88208dc08d54b662d906217df8bd6a1410e136812221bbc62f06428c5c"
    sha256                               monterey:       "13e57d8ab9fb2f9a8f785a3fb2fb1bfd6c2a9b4614f356a3abf47b8e46a7b7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe495f57a44436c80bd69c52030c35b300d8dd8658fbed51352a92ee1218b602"
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