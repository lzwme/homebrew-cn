require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.16.0.tgz"
  sha256 "d64c6b59abfe0d9363d26ff8597f40b70813c105545e08080f040a38e2142831"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "b0e2926f119299ed9da165d3717872963845e90126d2d9449dbcb11ea5eda37e"
    sha256                               arm64_ventura:  "5dd1239bb23d5d31d83ba864646d7e92424fabc0c81faf5873207db0ec8af14d"
    sha256                               arm64_monterey: "58c57042cbe8cc79964e6c11caf5a118363491a2ae40574bf74eeb85c18ee332"
    sha256                               sonoma:         "b33ab82b80bc5fe6f281142f80916508c198cdc971afb0d0405eb2602ba16a66"
    sha256                               ventura:        "0836a5d40157eea7d546d7d57a75b9838a546a28237a72cc5f0cbf47fb86bae6"
    sha256                               monterey:       "366a09fa3232531ea1a8e684b548615a1137e08976179f409ceae54cfaddd207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2cf96d0fff0ab3c6f01757fb1ce7c8ae9526e65c17bc51362f649e79a43f72"
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