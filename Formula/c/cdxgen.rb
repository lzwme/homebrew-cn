class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.3.tgz"
  sha256 "c61cf8eacac6403c314376197009f9e97ca083e937bf43cbc268b0103d6e947d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e858fbbc46fca0a2a47bf24a7d5dd9bfdae29aca2f97421a58e567c65c977d1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72cef05f432e5f3fb543cda727e3ad5be861ee011152b12d6f4ed608e714442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e1e20622693e992bf19b1dd641e64d443cbdbd66937339a3a4363d819dcaa0"
    sha256 cellar: :any_skip_relocation, sonoma:         "531e4c995cd8df3bb7ed9f4e58825157285507639d69b5ae71b4f60bc2b0103b"
    sha256 cellar: :any_skip_relocation, ventura:        "3111f54c62bbb12e2861e9ad45dd849959e75bc907c562d295d331aab27a2634"
    sha256 cellar: :any_skip_relocation, monterey:       "4d614eba3282f272c21e1036567167cdc2ff350f7fb67f6407ab4a299482a016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c243ae945a77b0d0a6717ace56dbfeb06518c93621d672876e07eb876b1857b"
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