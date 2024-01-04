require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.10.2.tgz"
  sha256 "70074baab40e9e004650d3c76601f1682df42859602a93f4537703d06635abd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f84c96fe7cd8bd2ba351e43aab029ce2ca351c25f081ecb97ee2243da9f4ad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b25f14ec5cf9ce5ecc630e82c476294557d90141fec7caeaa7036b5f9995d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac329b03cb6b7b64705027a7e8b5911bab0245ac0e05f234eaadf693c539f47a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a8a866e46e388f3bccfc0ee5ebba5588a70f37222db48aca3e6da2d9d2b8e54"
    sha256 cellar: :any_skip_relocation, ventura:        "1193705b7347ae2711b591f738be89c76ac33995331c6673f4c3b713644a6b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e88d1928c061b622d21aaf76955918608d6a51b3b201a23bad5a13fd846d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f6001619a1eb80b8ac6b081a634f941f1261c119eae33f406a4b6eeea3004a"
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