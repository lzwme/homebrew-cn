require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.8.tgz"
  sha256 "87e9bce0c985268e62ea338bef709aa778876413331a30a125695914778742e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13e82a9cb8b1dfa95d23cfc9bc0396fb8fdd2619f2b9b650c1c5979849d0882f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67c868083a1b15236970cc7d1eb4f03a2fe85747e71991caad7d058278934b63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09c633398fde1ff1804d2f33363d28901beaf5c9c1d76efba1476f6939d976a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fe81e5e6d7c8f9dfc3e69d4d39914394b7a49fb5e1ac87b78104c1512500b90"
    sha256 cellar: :any_skip_relocation, ventura:        "caee7cca92217bb6d4da4cf72c4e34092008ed2448f87e852727c485b6737cff"
    sha256 cellar: :any_skip_relocation, monterey:       "4e44e09f8c29bbeda8e630a9877e1442afac42d4324cad889d2b49e8219dc418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89bc4c35a4790616aad2c3e26495682e074aa8757fd8bb357719b45df9ae6242"
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