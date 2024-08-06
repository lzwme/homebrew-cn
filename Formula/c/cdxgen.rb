class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.2.tgz"
  sha256 "3557be151bd4c3ad39ead01a61aa4a4e374e0a6103377c04ac1f1e5538e2664d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2be1a8e6308dc814f7782e3d7d8086dc93dfb3238fd1b9b33b0e2d8f7fe1e5d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4fc0040d3e3d0fad4387b2e6cee5144f294eb4cc5b40f003fa0d3fb10c355f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e6013b4c0f81768441e9e8b25a44fb5be159b739f88aaea73c542206b8c4ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "a268e5fe619ab9d2723f361fca5e630e46fc417088971b7ba86adef6730c9960"
    sha256 cellar: :any_skip_relocation, ventura:        "09b6978462676b37e0efdc3b9ed75b079620f90458e110aaeaf4433a2203d029"
    sha256 cellar: :any_skip_relocation, monterey:       "7f8d41dcbc043a58b2a46f94999f29c4e2ad831ee3ea60fa314d64dfab5c3932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc62149a9154969ebc99df77cc7eb7a21fee99bc6f89029aab5071564ae021c"
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