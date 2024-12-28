class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.8.tgz"
  sha256 "6af08e7605682d33fbd78812d0fb61ec44066f8836073ea052ee8c673253d674"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb880f2553016fc3c1cef94fdcf4a3731f8c377562eb0f77bc98ffa4512c7ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840e5d2e25bd68f658ca11792b276ae132e3348749e82e9dfb0ec18d0e67b342"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e60f896d208bcc29e8b2b1c1e22200afb0ebc55d3ecae33c399b661a60890a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0e1174bd1f56329b0d43df5ed999ca08c254b77fa38c17f232118d1d93a0d7"
    sha256 cellar: :any_skip_relocation, ventura:       "ba383d46131071af2c9955e24e98e74cd5385e4a6031ab3937e2c413847d85a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05af70e7b7b852a4b6e977071146add9a8fa60ecad9062b1c18eb47498eeb6c4"
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