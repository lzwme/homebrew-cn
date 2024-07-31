require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.0.tgz"
  sha256 "4d4f393bd2eda52a2af3da12347ab4062313e033de4ff5073627cba31336fa16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea55a3dff62b2408ef9a4d2369dd9c613556e349494ea71c543215f8deecfb32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d766532db68939420ec16c51be2ffa6599c8b8cce14b6893083fb19bc2460b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffd6b165755938bd93c9ea4658ecc6704bdbbf312861e59233a9721adf0e09ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "07c5528f2fc7a064dfba843c3178ac10452aa63c90a1ff9773fe4b5986944dd1"
    sha256 cellar: :any_skip_relocation, ventura:        "3148db3267d60d10057b7d6be0a6e1a6f8abf57dba8133fa9359e6786bd1b830"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3eb8c8fd5136bd857ffd23a93e39517082befebccd3d9d1755cbf41965a2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ce20725f2804508fe7d1de0bae67f9e9201a5fa4aad0a2500af741f0760dce"
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

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end