class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.1.6.tgz"
  sha256 "05347a7d8428edb9395e418b29e9171687b41d904dcfa99987d4a0d86fb7dd45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6662634a01a945c9da41c98d5357d19c46077fee807dcae9af7e9d6c85096120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3084dab90cd07981b5499d2408fca91d5a79e6f419655ace37103bbf9002c160"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f41ac87767d4b917c12b47c54755d1db7afd0a5b9676619fa2f5c204069a874"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a94a0aedbcab58ad8aed2fe2b5918998f1228f9b9db6dacb88de86180819422"
    sha256 cellar: :any_skip_relocation, ventura:       "4f37905f13ae8148dd497fe3baf74ea8c68e893d9621185bd9ce432fb58abbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ba355528e6bb4b4c9b66db3e3ef484ce081e428aa53888e4423c587cb6899b"
  end

  depends_on "node"

  uses_from_macos "ruby"

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