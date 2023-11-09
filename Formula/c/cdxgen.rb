require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.3.tgz"
  sha256 "18dfa6b7e6df06f30737faaa9b39b37330fdaf9d869169b30e39f6ada763c70f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d86f4873c3ff8c6770ff1c5076f35f1358d46b71438f60841e4b71447ccd5496"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb7d70082ec0a762a2361247dd3cb0bb794a0477d9378ff36a4e2e6896da16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8839c9bf760c4a8baff25d254dd74cf1d599668f09fb76d641377203549db9be"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ccc209be04c229f9b970e85b8d23cfdaeed4e5f43f112c538a4a499ce559dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "8918da3e29caed925ea394afcdd2629474a3db9e75d58a9d50def1638c921129"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c51c9ad42a15b05100f47204cb41aa07e0d7ca035d1ba815f0c0d06462200b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50828b5fa7cbe8477136c56a3aed21bdd5a0d691f8b0a6f7cf4fb5ddf9b86eec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end