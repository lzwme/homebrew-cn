require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.9.9.tgz"
  sha256 "00d7c0f5415696dc62f1bfa884e6fa7316f7143aff7a0709589ba3328bfb5ba4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe187e2d10627e6d0180d32513713b771192156866db6b3c58860a5f35d5c6bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "958dedb7d6aef1c25beb1c61393e53c8efbd09fa60f23ec3ea321ce3076a7cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45a59cc29f05e2b38b83404fd0d4d4ec8e002b830d5a2a3a48a91da1ce337e94"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff84d9f8c4e6683366a9e93658d376467947d1fade9a5f4c6ae24ec3ee8c10ff"
    sha256 cellar: :any_skip_relocation, ventura:        "31ed098016712cd0c475426b1ffee4f9f54fd4aab24344a82c20114ee93715c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a837141b2f9ebcac2ebc96e9163182d5c4c80aa7ddbd73e9e629eef0b2832d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20110c4b50a7e96ca510edb569a37ce4e9612e24db54a9f1b00682ea85e3493"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end