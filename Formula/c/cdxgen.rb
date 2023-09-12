require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.7.3.tgz"
  sha256 "f73feb116174c7c34b59a3a8af45244f965242efaecf4ab0525298377403cc76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be6c0b9f525fd49b14c9a28da045a985f927681f0ee8e74fd395cb2fc77d3cd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8011a8a141a85b09c80cb11778d53b35d3bdf6212ed7ccf0b86c0f94e23df2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b17b6c2cd41c022d070962440be199a84dcfe0c5eb893deb531ce8c210c57fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "07a5b644ccc8d1d8009dac4f6dbec6d008800f279c132fd6ea1399e7c0e5da1f"
    sha256 cellar: :any_skip_relocation, monterey:       "f559a6b5e2d31609857ca3134281da67b12b51dff8868796cb3378290900bb4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b7018ffa6e11c9de64a9758feacdacf3862e1ced1d98959694dad56fe0bd67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1df95e745cff16316fcd408bb96b4992b0eee1e76ef86cce481cea070df0c59"
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