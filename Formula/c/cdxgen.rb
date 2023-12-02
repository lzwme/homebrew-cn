require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.6.tgz"
  sha256 "69a0200140caf31856818e7556dbf22d76432744d550410a6b72cff730658ef9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d2a65b206010601e5d5573693920d572225421dd23385f8f68400bc13acb87a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab7e2fc17d8659f5b88b9adb809c5da3b877afadb091ae602d43d9da0c29324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0492bdbb0bdcbe3a8e26c58f0e064f13f1f50896df6bee0ffd7ebe9ca6eeb65"
    sha256 cellar: :any_skip_relocation, sonoma:         "db326a6b1bacfb74dce08d735bef6b3fabd0b3abc9fb7b322a7ddee3625a08e4"
    sha256 cellar: :any_skip_relocation, ventura:        "eb029d3079e06825f5e9d02924a31b12e5a6b24e0260cccbc92e69de334ed1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "a08ad53c48fbd361d811b5ff5836d649a70b4f9706866d8fb2920da922a9f1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f4ad952d72aefff7ed2b86bb39586faa17632a30a6de5f8a580e5cef9b32e20"
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