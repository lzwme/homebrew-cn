require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.11.0.tgz"
  sha256 "a5b7fc4d1da889f05439d71d7e3297e1a8a16e9dc6f41286a85371e0bec7625a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d75957042fc6d155198ccc2f2231cc52e70ce12a5897c391a99a53c7e4f0de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72af4106e8d2cda92f35fd12f139a0cde2f69d3a30d8710792ea5cd277354f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccd8ea50992d78db318821b50aad0f5b20dcdec4eb7eee2395c1b4755b1bc408"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b4a393c91be23dc84c6db2e5d50abb0d520216044d62fdc615a5fbbd4e32748"
    sha256 cellar: :any_skip_relocation, ventura:        "d7cbdbec26c910f42a5b5f41e4cd694a8b519320cbe08cfca1de4db5f1dca8cb"
    sha256 cellar: :any_skip_relocation, monterey:       "f9de5bd0cecb9bcb32857c6d69361ab0ee6f1d0545246eeeda86e8ba16893f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c89323de5bb28813e81281e1fe1b8b486ba428ad2ad7cf953f9ba80e7faf922"
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