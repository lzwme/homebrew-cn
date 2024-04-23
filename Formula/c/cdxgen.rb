require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.4.3.tgz"
  sha256 "f7f8ba0ca44846617c324f27f819b94cbace579096d2d3688ae3796aaab149dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db51fc0b67c0a1cd106baf71a1c9e2268b3135ad2ebf3f24a853752b479adeda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f863612c8eb39d815340f281c01287953cabc1ce80a78e21a9b9ff3b6381d75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921db339497183ac4bad98cd3335ec7ba93e27b050fa744b107dbe94fe17978c"
    sha256 cellar: :any_skip_relocation, sonoma:         "971a4b89a8249ab8a1ca17f891a7144310c403f81789d90cdf2596389411feb3"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7b54e21222d2d4ba2732f0485bf9c1770102dac5eb9dcbf576989caa1ebfb0"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfd90c218174d61946b001b329552172b65e4f53f38c38321e546d4fe547dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d34afc283377c6c03f13ce4fb43501797fb5f643584070ad206b932b0125f69c"
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