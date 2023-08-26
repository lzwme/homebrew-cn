require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.6.0.tgz"
  sha256 "7c84b3b63b38dd74fa7d757aaa70c6d7f4878f17c4667f511761cdc5744a0272"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b37d7fade47320b98702de63349f3824dcb84d8ad244bf2072071f0177faae0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b07e6dc4a70c063215639179fc2f4e9122cb65076ecd1a7dc1ee0747e7d9b89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "236ccebc97577e5abfa53c0ee3f3b67e0d87bab0857d3561c04711b3396a84bf"
    sha256 cellar: :any_skip_relocation, ventura:        "8f88e9e8424a6552f156fe0de33b2216f0c31ef36f6ecc21ea830ec9ab16901b"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9374216257487f56ab2ddffd3f48e6e3ac40cd090bdeb65b3eba2d7b8a0471"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3c01fef1c9e483bcb1dfa1fa7944c8a8897fb6f871b2cb4e657822572df4de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc43dd022ec3e14cbafa39955bf189e7e1a16abb25ad92c3e1d0a9d1e6eb495"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end