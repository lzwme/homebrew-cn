require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.8.tgz"
  sha256 "4220743700bf34a75e9cafa5df67b9c48e64acb4e99beda41ec9a49447a6d534"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d4e52ea9f54130a1c3184149bc04fe5c230ba99a8cd55abaf0d2fff38542f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9fbf7ac6bd5abf4cfdd76c2e8596fc52ce846af2b4cc4810846cb2a6cea03d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e54080b51faf6108aa96328b66fb93321d009cdd3f2069782895a6d58015123"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a29277ad0d7fca5261421d6a0fad1d2131ec5ba8cc8471ce678e2ffacc4772e"
    sha256 cellar: :any_skip_relocation, ventura:        "04487e6e48d04aa2fa22da5c53e0d3e6d3c00675aeabf3343068005ecde077cc"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0b640998f15b397773c21247fe94e9a687793418e15874b4380b92662c908d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f475beca4dc63d88e3f9b83c6c580adf5d6059bd7d2ba6a97ce85b4c06f6b1d8"
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