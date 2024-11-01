class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.11.0.tgz"
  sha256 "c63f10b072d669885701ce7cb2d9afecfe4e402a8f8b12dd84ba7644f8d53199"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ebc17376f786ebb230bbfab82e0eda301ca849ecb2e612ec7f3141613e319d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b31fab867e9cfc9a86b2106806f88640992cb077ac2fdf43e0f1d4f3c2d8476"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93e87f1c3225af1bb06361a421a5efb32191c3cb85db3e19740bdcef5a288b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8f8a024139914e8acb42da8f737f1ed5fd53b652d473b809c4f8425f6442f35"
    sha256 cellar: :any_skip_relocation, ventura:       "bac4be1539f11545c74e1c089e7577128bd7396a13ad8c27a66e2f127faabcbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f2a3bc9ff05d623e53a72fa1a3d01de40a6ab48164647f80033f564f63f73cc"
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