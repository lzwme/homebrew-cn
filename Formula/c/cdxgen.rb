require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.11.3.tgz"
  sha256 "85299e1a21e49d859bfb1a3b95dd857c7b11b503f3f92c18329ebe8f47a0e384"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ef6573dac31739d07470ee2cb3daa1be8aec16ac0e9e86813e19d10be479309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5114e19b043f88cdbf64f71d1f33ce9d008aeb3653e5167a91768ae3d778d1dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09546cb5182739d5889a9ab37f29686468dc01d7c824ca55549764286698a07b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7fb6e64a6d1b615b54bef9822ce0ed6c1bdbfb9f5eddea90ec0ebf3085663cb"
    sha256 cellar: :any_skip_relocation, ventura:        "c6e4d37b58ca9589ca05cd04b6d596c536c2fa1778c2b607c8f58f628c6d53b9"
    sha256 cellar: :any_skip_relocation, monterey:       "21087148619a1e73b43c9032f6c56f6248a7de7b5f2d77ffbcb5a8ec8eb38e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d475d73d25a7e9c73a6d852a178c99f8079225d41c5ddf0d83a522134be1a4"
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