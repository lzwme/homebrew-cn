require "language/node"

class Monika < Formula
  desc "Synthetic monitoring made easy"
  homepage "https://monika.hyperjump.tech"
  url "https://registry.npmjs.org/@hyperjumptech/monika/-/monika-1.19.2.tgz"
  sha256 "92f4bc11b2b1445ddebd10a7279d7fbc1c7da7ce38d90466159f8d1fe7d644a0"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "9575b082a5b9b2370b544e3647dd050eccbb8d64ea0df56219f9eafb5b2352e1"
    sha256                               arm64_ventura:  "21baf3e2b979fe6a0718542cc479c435ebf3f7f0ef8d0b78fa51f10529f4936d"
    sha256                               arm64_monterey: "975517775e414b63cc501ef044f57e1cd9c8c0a604e32894203957fb3d0fb84c"
    sha256                               sonoma:         "4da89338320f378d94061e726918d5ea6cbb0512f3268e244e6f18b17a4483a7"
    sha256                               ventura:        "89dada2dc89e1a4c18a5f253fd346d01c9b6302709724c9f6a241d667c09f331"
    sha256                               monterey:       "0995e3d379179020bc67b42019598a27c38c2a97f9da349c09ec475a9aaa70f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ad1742607a2b25c71f4a7d579214d0ca31c2f353e9fb1d09a5ac620fd06e5a5"
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
    sleep 10

    assert_match "Starting Monika. Probes: 1. Notifications: 1", monika_stdout.read
  end
end