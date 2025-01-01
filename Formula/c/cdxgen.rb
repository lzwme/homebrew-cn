class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.9.tgz"
  sha256 "28e4902a6844e000b12987e83f46c05eafd1ccc93ed8c59f3264a611090d6667"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118422a3c451d0c71c9aee8cc74c0421c7c386dd158941add379f64f97ccd923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb551e38034b48653a5a3970def9118746815c004a206b6a51fcff63b860193a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1877becf5669e7e227c058ba35de6bcc08f2abc70ca1492d1cc4bbae0d08c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "d68a39b4634f67d3f9a6a59ba3122e99eac80572290c050115f0ce03a2ce6ebc"
    sha256 cellar: :any_skip_relocation, ventura:       "a777c6caa2e8b05dfd3c17f20b63e5eec532389215d89144ef2eb694fa9078c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3684cbbecdd700864a2796403c14ccc42c5e8eddd51c70ebf5fa795404d4cdc5"
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