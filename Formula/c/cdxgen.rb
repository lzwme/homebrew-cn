class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.0.tgz"
  sha256 "c931ced0a0e673fe09895773ced4c196d58db4eb053a94a7e38879f25e611302"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3cdde4bf47b92e076bc094b3273625bd6409b5f02b4c71828cc9b95150dbd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "694be565b710874aadcf3266558f78b62edd595294d0138fa87bbd4e8798cd22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1c75d4c55803bd824bfa82b02d168346f7f7d56d4dc955a0275439802f86b33"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac7008c33ffd3dc006f9052f2e68383c3593138cf7e0ff17399dbf083ad449e1"
    sha256 cellar: :any_skip_relocation, ventura:       "38f3fca97d658924c32157565eccd97810ee0a9c86e9ca0d614988d796d1853f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e598960a099533f964c6b9ca8ca7605c4ce987f18a04b365ea9222c15e816a"
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