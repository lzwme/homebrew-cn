require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.3.tgz"
  sha256 "ca394cc96a80608b4214ff80889c5ecddf14b042b3ec5d17981092921034b2a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8fbfbb003388ba18f5c896bd49a85e6b6ffd9e75c83f6b1044f67d12f482309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dfb6f43df6c9cc4147740e5927c1f09e75770b58ea459ed0b3a0d0f845998d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b57c46325c16ad4b32b056e548e9b665c1721cc61c9e8891a523797496038011"
    sha256 cellar: :any_skip_relocation, ventura:        "59cd827a41d4c5b790c3071f5a7782f437389f69a19b18a408ead75313b7275a"
    sha256 cellar: :any_skip_relocation, monterey:       "33a3e63063d1b3ec5cdb7e0c2a0d902b7b13fc94afc250856e39c697ad10f0f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b3bec8fc381319dacef957e549f37e422292e2505ed19aa45ad3d43bf26dafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543492d6a075dcb02b8ff50d3d5ccbcbe358cd8c30ffa6fac5247ac79856b7a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end