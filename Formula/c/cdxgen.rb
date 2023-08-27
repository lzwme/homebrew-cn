require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.6.1.tgz"
  sha256 "55e3fd699aa217988593a8b98ee8a83a8edacd9bb294eba12311d1a0ecf090d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdcb2bc25eba3f9990c4c109ea5b7b31f3a7bc81446dea3b854d4888913bb06d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a16746f071e162524b1dfe0db9b32da3c5e9d9cb3d6943dfc72e7a5d149cd99a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b76da974766940d38ad659b2f345052d8984cca6f75c0a8563e8566d4cb9b798"
    sha256 cellar: :any_skip_relocation, ventura:        "cf91c71ed6de73e2104184b76f01fe3cc7b7e169f37a492efbb6cc9e4a1c89b3"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0349a37ba087bf3e5c04b44129d83c96df25abfb13b6b0454b88b96aeec97b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef8760ceb3028095a2a5c8a3bb1067c0e39343375721003f185d9d9bd28e27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db26484b6b4013356f2036bc924778f6bd72247e9034766557c2a1c0d370b85a"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end