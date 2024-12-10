class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.6.tgz"
  sha256 "352824fa445c10ea7332ab86f7e0dccb58bce47377fc4522272adcbc3f1bcd21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15384f2119df6dcf09b09500b83d6a349fa2a54a2f5c0e734c60050546952b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248e42c3650e9f169f3d578a5b2fd7e2cd90b93cf736156e838c60a5b0e225ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc8e670b832d9ca0366263a62db14e2b16f397c02d44ececebb53604e31681ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "286b2c43dc34be714d3bd24c3f9b830b15f9a140c47614e3db140769cbc53fb7"
    sha256 cellar: :any_skip_relocation, ventura:       "a00629e926742522e9fe60f3eb0258a9a5e3a0093adb3e24076559b5b7c41f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202c24832ae9d5571c596cd0ffbc847832110e6c86fab54f737b90421b71297e"
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