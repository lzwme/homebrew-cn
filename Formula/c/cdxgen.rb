class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.1.5.tgz"
  sha256 "c0047f4fd88aacdf540c227f9b5309f978b25aa562c89ce716581b7854ce93a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3791795f016d1bea3a42931dcb10f8637b82cf5c5340ac909e94f4aeeecc41e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38f87b84b38906a6004cf03932d21ff8ddd960543a7ac0c5bf0b886c8d8f24b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af363683479c96eba872e813cdbd7f73b1fed5745501000d2ff9ee7d8eb29b69"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d46eeba3709523e51da751ab54260d822392a62ef2f92cacba5d301fca93115"
    sha256 cellar: :any_skip_relocation, ventura:       "a75a94f01b537bd316d2916bb0fe1c9c63d76a0551723a4be7249d6db7581e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9740071a1901545abe0e13809f4727e09bb865f64b400b8e301a3606e090a9"
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