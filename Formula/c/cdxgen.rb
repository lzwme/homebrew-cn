class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.2.tgz"
  sha256 "b6e85e7144981bcffa51df66845ae32dc223b25d3441fb3af0a67583e9c257b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff5f793565a87ad3f4cf38cb634748cebeda4f3624d754ad03cb1ba45b0bc31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d02dd46fa4fa11782556c092a0f85250920353298b2284a7d6e0f9788d9b8e08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "962ecfad94ca2cd2c4cb9fca779392eb07cb0d290d00fe372b0ed3f5b7a9d065"
    sha256 cellar: :any_skip_relocation, sonoma:        "17641d623894d3c1a8a43f108189a8f41f84f42bcd53c031cc855773f709f407"
    sha256 cellar: :any_skip_relocation, ventura:       "20a6b55a81c34ba7af42ce40a7b70047a856aeca43acce2f907ae4f9f7485e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1d996569e3e6510a77837f80bf4130b28d29ad68438775b4359d79d8c5e080"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modules@cyclonedxcdxgennode_modules"
    cdxgen_plugins = node_modules"@cyclonedxcdxgen-plugins-binplugins"
    cdxgen_plugins.glob("**").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules"@cyclonedxcdxgen-plugins-bin-darwin-arm64pluginsosquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
  end

  test do
    (testpath"Gemfile.lock").write <<~EOS
      GEM
        remote: https:rubygems.org
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end