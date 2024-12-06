class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.5.tgz"
  sha256 "16e9d7a11336b963999d914cd00b8c50c3a5f8f23c6cfefbdb03f0ed09347ad1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9a1c090a29c5734d3d641439b0d39befa9e5280b097edc07b0a086292f60ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f29dc6365187be5357b44c0be5fc0c6f7b0255b26556d2e2ce192cb4cb0d28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "565d2ab94e7237fb332b9e23b1ca6b6f5a97669e662d879e1ca3277474a8eb15"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ddc9bc8475faa2c9e73b03bc3a8cc05c3d15b7a5654e8990bcd1eae91e64bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "f1e33682642aedcad2e0b832bde857e63ffc313da37f82bea4f56a425a5776cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bcc6461cd8f9de86d64a0c171186f56a5c64a9a9213c9397fc193e89a13f620"
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