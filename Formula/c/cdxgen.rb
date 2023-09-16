require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.0.tgz"
  sha256 "dffe4ad4159b6dca46f1c4dc895d472a087ea51af73fe43807a257d5b9709f27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f78493c71664f19c4575558d3bfe18aac18f31e9cd1fcd2eb38e89a9eee3407f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55d26a66ebc9f2a62c1135654ef928f83317918c90875d0206006b78b22b0752"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb64126e8b6f455077a70c31a2341989be096a4ebb9283c6a36852961b612ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "25527567b9ae43a1f55e72424277720d1a32ac5827e9ea46648febb6248ac8f6"
    sha256 cellar: :any_skip_relocation, monterey:       "df93ccadd85e1d191fe974ef8b3bc7dfdb6361168c8ef17a8cbd23b6e501922c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc5f61f9662c5aaf9766b7c90d186c64dc09f6c8942cf3c14cd25255ef271a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a61f013242fffa84f8ffa22266464ccd02287a3ad33c749fcc785a34c9d5f2"
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