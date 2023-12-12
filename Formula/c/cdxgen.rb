require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.7.tgz"
  sha256 "726648050fe25343c89e1845e2212756cdbc9c3078c77e75dd09fccce719f8a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bd83d702400f8b0d3f73ab406c5214ff8eddbf45b0a7a6e442977457df1c7bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45fc72abeb003fa345e97f1c92f94b5c99eaccca3f9e33878754e8f9881706d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb778a14288271400fc64e2c371bc53c562446d9a12749b76728c24cf7fb0da2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d2a4a23c4707c3034eb454b806018dea044208702cd4fcdf0cc0c54b0510d96"
    sha256 cellar: :any_skip_relocation, ventura:        "5d4358bdbf7fefde3c50062f9aba953b0cb608a69bcfc4c8d6ce40eba5e8ecc0"
    sha256 cellar: :any_skip_relocation, monterey:       "68e8d0ddbde096a37179b570bb5c137ffba769ef954fb03a71c257a3e2bf0cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc81a1972f8c4008fa1aa5c4cb0808631f7c7b82a2176f124f25ca2ed9cb2555"
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