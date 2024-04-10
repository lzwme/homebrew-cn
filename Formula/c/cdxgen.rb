require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.3.5.tgz"
  sha256 "42eb485240a2c831a64e670c3f54854827ee63190eccf6fb50f7fd2a37280d16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03b90a4e500faf9b6edbca75a732fb58a52d0e44bfb1975556f1dc45ec55b37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9258be754dfb781f63bd07ed71c97d6cf38cedb5d5952cd86245fbd7fe22ac9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d79f6dee132be321450cc89afa30758f14424e952b08b98bfda864e741bdba"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf89ce11c5078dde687ff433ddbf17e4a555d5013f00bf3aa4fc52bdd7293f3c"
    sha256 cellar: :any_skip_relocation, ventura:        "8c36ce28e95043de518acc5ec59ad2870e7f6b3a2688eae05a227a34dc7a2248"
    sha256 cellar: :any_skip_relocation, monterey:       "4033fac4bd26b0a251f5c7df5f22098ba8fe44d0fc8f2ff0b615dcf0c743cbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f2ab2d4f47906115c8cb7d5926a9301b1d2af5bcbbfd35c0ac906cfc2ac56f"
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