require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.6.tgz"
  sha256 "f3cfe25ba086897d592d2eeff75827333608d9b24bbe16d61fee7f950bce952d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67730e159383f97d0e28d5e8899eba706929d3f835054bbd89467c96d4dab0a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3fdf3f5a1c4ac6ac81afdb041b275d5a7e98ac9f12f9eb7a408cd62887a5501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47e505bbf2fe73ba101dab996efed0e984d5e0c7601ea3dde4e7b9e758ce671"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb0c96e41c504ed40975a36ffbb56f2a39b532c762787306a9161bf633dcaeb1"
    sha256 cellar: :any_skip_relocation, ventura:        "3788f2561b889caa21c3d1c3699d11c353ab83bedf6e701171afc437da0cff58"
    sha256 cellar: :any_skip_relocation, monterey:       "a0c4ef2c8a976a118051caa66330d3cd3c1c9afe7bc040e58ad11c2afe243957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e930c69ecc6540f523bd9b9d6095ca968f7e3b8b2af9a2a624de943b75ce73e"
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