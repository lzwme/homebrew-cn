class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.10.3.tgz"
  sha256 "f0cbb3aa5862de865b2514f62ff62c9d80fa3f927345fce1c4ac7d8cec216f3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b26cf6fd77b1d9cb8acd9e734a0dbd45a387cb9a767866d4328c4d1f6b5049f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73cceaba3a5405536caa683b25c422e1d27f46a675f69dd4cc17a411753f5962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb81158c6c9d230903e25634c9787edcd05bcfbd8571450fb33147961241a631"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d15fc11d89d1d3a7957bbcd9af57d7b8ec34737e6128b561092e9fe4fc3239"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7d9982d4fe19f2a330826ea22916dc697c4d593cb7f63799d66d9773fb3fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b44efe8d8df346ed3601a2383682a2290cb0e1fa828f10e14b4f984593e0e52"
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