class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.10.2.tgz"
  sha256 "b5ed9dffed596f446dd8609b7029ec2a78eb9f3df601a691ba06df16ee2bc217"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577bc8367d155cacd3758d9bdf149c41aa16b217f9b0435b93462446a932f647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cbaf8963a63aab3b6007e1cff66ee0ed7185062b4c53ae1c5e303a57e753c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba17bc8df595cfcfbb399bdde216d211d221150bbf0e3e599ed2995cfb20dc20"
    sha256 cellar: :any_skip_relocation, sonoma:        "836039be9cd1bd4675ffd77e3fef2ed1aa4b871f8bd57bd4cf50413f09593360"
    sha256 cellar: :any_skip_relocation, ventura:       "59c67c60d5dd23928e8b862e6d67e96b739e41a0325d2918911f346b44014e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de92ea3c88dcfc8d60187ff88552c8c54739254d4ac2c6e5ccbccc8fc058e15d"
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