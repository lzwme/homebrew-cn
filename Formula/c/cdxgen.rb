require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.5.tgz"
  sha256 "d3d5674ab4fd10314d830edf922682d95638978360d3b95c0a6ab61eaeaf6611"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "444683a26eddd0d8d27ea7ae6ecf4ae4460fa9169bd9213955e3156a0149e323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "604f428d4aa1847725dbed7c2b69ab137b252d7e2e62510b762114be606ca7e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ed182a6280b6c441044643021ef7870f8245002c0789079229586f8aa5ac9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ede01283cf96bd9214493fd681f79e5f63b1b680edfffcc175ac43cfa270033"
    sha256 cellar: :any_skip_relocation, ventura:        "8a6d04434082bc2cfa715412c082d32b4fa8a44a0367d9860ce0e3e09656282a"
    sha256 cellar: :any_skip_relocation, monterey:       "03c822ff71ef565fd4c8825cbd4a3d799202721498c6b8afcc21c9d003eac9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f33fb68839e7b977a4511a6afdfa9229183dfb3ed661d75edd1782f3ab43c3"
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