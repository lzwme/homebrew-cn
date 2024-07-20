require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.21.0.tgz"
  sha256 "b265ffce61fde24aaf51e6c84e30d158e3555474683598809d1174e768d61752"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "a495a0f64d3b7e7395448b33051e6a7d259d2ed48d3e86ee6092a02c9aa340b0"
    sha256                               arm64_ventura:  "dc829a3cb82bcec6aec10db9f65f207a5476c8c1f4e505d7a497589b8d7e3383"
    sha256                               arm64_monterey: "b33c3e773a3f2ef3af6385a84933d09dc35c0c9bc36ea939905952836446188e"
    sha256                               sonoma:         "b38d394e9d84a701f2e8614277f691338b9dc1a1950688f6d8ae8a24453da81a"
    sha256                               ventura:        "5f792ad344c6b4bbd62ad93535be26dde1ee44a3e74fe466059f50e6bc39d5a3"
    sha256                               monterey:       "65a1a336b6e1c8651424680b14903134f7637b1af06c8a7e722e114663be6181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddb16c9dcefd747dfca1c16ff3ef19d2e626cf0a3004cf88a59bb7397f98873e"
  end

  depends_on "node"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

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
    sleep 14

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end