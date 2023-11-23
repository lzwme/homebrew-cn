require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.5.tgz"
  sha256 "cc11c7039c89dbe462fb0d5e817a909c2c9bfda44bb0e22f86e30cbf731b9e11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9962380d143e88ab92cdbcd904ec404af7ab814f0044729bb0e56b8375b8d238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2b6bdb79d7f0f75d0b06d599a9edaafa26452f5c6e3cd3d0af0e1bd6b8d0d24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7e874dbae53ff59b0ad01e26398605e0569a48a9c4b999de1c679eeb1d475f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2dc711ab8a3383399d21a3448fe8640012e1b6aa41f8f9ddf64f89fc004e3a9"
    sha256 cellar: :any_skip_relocation, ventura:        "253df6ee21df969779698ed31a193a41cdced27bb4f97cfcd105b53847730e81"
    sha256 cellar: :any_skip_relocation, monterey:       "684453d80554a8352c0c8e6793e245ee4f840b00e5317d66fa0d8e73f13b275e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b610f8c0f3d5745f41bd1e9fc22c2fd11852caa73e440a6f31cca277088b4162"
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