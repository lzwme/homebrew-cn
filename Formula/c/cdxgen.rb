require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.4.tgz"
  sha256 "c9b804c399652a11582dee9f6aab37f54c74077ba5fa7b94cddcf4a2fa22ab2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "815e5497357b15cd44577af5968aa00659b881739d11699d43ffb1d233bf50d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba60a83bb24d8fb1b723544b1c497c885be667eb6f302942daaaabb7a7c7f28b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfca5324340916e6075309440f5bf8cde9fb78b151145dae904c6afea3c3eb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7a1c0734c3a76f7531176f13b04291dbb97224dbdb360807354c7a24ae2d7f9"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbd47a58db4a8d3277d574290dd2344b69ed7022d704943e288ff91a0ba7a96"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b77eaf659c1cc3d1f585f1323f9384ba3df2c6b514bb09776504aac5401826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a459e3a0b93e0c51a57c45e7f146c9170f839e144e289fa91318d856486d4c2e"
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