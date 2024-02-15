require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.1.2.tgz"
  sha256 "8879e86370e1e0011dc1829444a38f48783efcc71c38b75337c679a87b050dd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a247aeeb2123222024519669fa1532e0feb8695a2b68346a4a0e307336c49cdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9e20a3be0b5bb9127549e5a92d384c7ce3422e86cb18ba1b0a2650d584e3646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d579eb4da223f99ac515ab35477a3ab6d3e8b25802875ecd5eba75ed8b0d9c9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "40d4ac681f24ab68b1b828a1cbcd61b57a3171cdea328b36f00d4d6534b01bae"
    sha256 cellar: :any_skip_relocation, ventura:        "e25d836312308b55b94825ecad2a24de8a94e186bdbeea3babf10e641abf996e"
    sha256 cellar: :any_skip_relocation, monterey:       "1093b54c6b5899b2621f282500100d52c14fe1a26d6fa178844d121089357dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8836bcf30f9d06ba022eac3a5ff9a2c11b80c60e4e6cec6c9ac8e9ed5b69ba4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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

    # remove pre-built osquery plugin for macos intel builds
    osquery_plugin = node_modules"@cyclonedxcdxgen-plugins-bin-darwin-amd64pluginsosquery"
    osquery_plugin.rmtree if OS.mac? && Hardware::CPU.intel?
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