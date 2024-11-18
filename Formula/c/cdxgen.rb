class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.1.tgz"
  sha256 "6fa50097023b7279e6b3a9f07669f70f2d4956dfc6f6255f41761b4abc0bdf70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08c879859d7de5e5dab70f87c60ef3b00ba855da9db169222c2bd8c5fbd6e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d219b34da0dd14bea8a940b0d56a2ac748ff12f55335af88cf0bd9ef98f1e730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03f01e8225ccc3d1edc09048610809d739a8157727734b5d21f29ba223dbc755"
    sha256 cellar: :any_skip_relocation, sonoma:        "f99d7a54428a5b08ddc74d2102007430291c23a6357f9847d6159fa21170d63c"
    sha256 cellar: :any_skip_relocation, ventura:       "d4cc302f5e6116d7cfb103a9caf4fa3935431c1dfae3e67828594c39dec10061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84dc66ef70d3c132a97664a66bc5b97cfdc4b90f379ae1e18a143be588c556d2"
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