require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.2.tgz"
  sha256 "1ccf417afdfb129dc4ebb9e15e5929a5c7bedabbc149e38c520407056c4193ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bea3eaabc33db12ac02a51cb006919e08ab5d1c56c485984deb097d023a2bbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f3da267f2693cdc37a5902f38258f4e05accf9613566c4170360cf3e81d41b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8713247dbb3fd38b00596492b0ecea6e78d2ac3c1f044c9fa53362ff68caaf98"
    sha256 cellar: :any_skip_relocation, sonoma:         "d48ba87d527e6dc23ba55d8a459d77bcf35dfd9595972d1ef058586cf942d250"
    sha256 cellar: :any_skip_relocation, ventura:        "6f81d86f6f3daea62b94de7fa4b1d5da7127cc5787a536fb731c008472f4a8ff"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb44d733c751ea0a73792247f2d53e329af74405592f7d84bee9621e84081aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52dc1f5fcf0146019d34694a6188f57f95f66996f021f1964dfa5ac6fad7712e"
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