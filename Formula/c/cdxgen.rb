class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.1.8.tgz"
  sha256 "14fac344f709b5a8e065b6074f7cca196cc650dea40499cc290fd816e699429e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b77b5697a8430d3b3e82e6b67d044fec8893b6fb43b3bd5a45b8f42cf894dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391b1c3d71d5833c62b8230e433527819204768b26e38a64ec2df53f7748f7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05da96bdc0a223b39d7bc127b5e676c3f048d31bd190166c097d751a725c305d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26af843d5197aba53928a6e97622275e4285dec03415c9fba6581c52324819ea"
    sha256 cellar: :any_skip_relocation, ventura:       "b6d7f07c3335839b222391e25f7b14a3c3c69f01dd3d76e2fd25156f503503d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc711d2fe1b77cd9883f464b17606cfae8d7e9df26189e1475c8c5c1021e077"
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