require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.2.6.tgz"
  sha256 "31c37671483c27e6b3310de2c940d3ef9493b57426de1a1a7e7779679db1d46c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afa697abbb097e77a14aadf03af28bda268c4693b5afb30a866169b081f241bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11fc75f86e6072f0ac653b770d8c97ebeb93b542bc2e1f6a1836e5d25827a7ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d9711189ecfea846c25c1057b1a4815b4c1e6911fce8b4365d0e1ae2e4f0ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c3ec7d5d05c52101172feb2242831c536d3434ab6bcf5965a626c4d3d7ee676"
    sha256 cellar: :any_skip_relocation, ventura:        "78b2f596716eea3ce618b318fae24368f3d85191cd79aa5ad8fa5faa736ffc5f"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d5f818ee15a4cda5b222a9ff7e9b6810831650cc5361364f1e917e8006c87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "916b43621be0f7db002bc20cee2f69642d8c2e281af3aa52c4c9430b2c5b3b9a"
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