class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.3.tgz"
  sha256 "f2b36b2ce1d020d8f10b52960b14642da27bdfeea805815a6a292586f6b75c48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a6e44771d53d5e06700dea86839794f9f385bff2ed36bb9e56c91aea9735a9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87fdfdbd1d23e7c67496754a25e2b7b592e9e8d97683730bced9a93e62c68d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08ae3638ab2ded84b122a19e02c9196bf0fa422b2da79b99ae1eda5c7ab21dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "23bc56226de8a53bb44ec6d0f414274be159e6148ab90c6ecffb6f29917cf05d"
    sha256 cellar: :any_skip_relocation, ventura:       "2d3fc00ad68f2215b278f80b161047e7be854dd6afdd39fd6960f83b173946e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "176dac3717ba5d0272574f319d070c4567f91e9490e69d247f399fd7286df953"
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