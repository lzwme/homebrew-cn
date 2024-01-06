require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.16.4.tgz"
  sha256 "b61e4942bd219cdaf8f440b3fe1bc22872f56cdfeab1e3007bc03a356fa5bca6"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "b0bc6dc747a4f5abbd0fcbd825c31feb9b2d0b99190cb54521f78e6d4dfc7278"
    sha256                               arm64_ventura:  "01b1821950697b90a54cfe413721cf8d19e543c8586094f4bde66a49ee13f295"
    sha256                               arm64_monterey: "c17aac3ba0bec0050d8f3bde8e0e028b414d1f8dd9e23905f155b637e9b80f34"
    sha256                               sonoma:         "e0c86c5a397ad0c7fc559a2e4b2eb3fbc64ed263d42ebbf8c7e4c74eb7f652f7"
    sha256                               ventura:        "729c91a02c708e96b98c747d4c29b27b6aa3bb42b172552a0028c0a542064bb5"
    sha256                               monterey:       "cc4dbdb0aa38ffc18735e924a6af279105f5ddcbd1f117ff719f059d91eb4419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcfc575fe500c12130e5a3f61263cf443b08e38bc5770e275711c9b8f89ba10d"
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