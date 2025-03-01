class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.2.0.tgz"
  sha256 "97da7093147ba6ff0e791e502a83dcd0b2c2e83ab9419cda593e5392d033fd91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e236502dbb30e0d1c33ea2aab6bbcb5a2ae5068169fbc92bd19281a03fc854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c764bf2f9dbe3376752f47555d031486c07d17802af31cca0e6487991563c81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ca26f2b460555e08e625627e1d2d58adc124bd68871ccadca65343e107834a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8ca2f600a28db4dbd9e6d79c6baee6ab7a63a3dd9f087d320b6e3ba06facb58"
    sha256 cellar: :any_skip_relocation, ventura:       "11385b50f29ffe0ff82c85cc134a96be9e5fb6d862b11ae23fbb41e1420d145e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b8a30e88a3951ebf97d5ba9d41089939a9859aa23f8f7953bc5589577c7c25"
  end

  depends_on "node"

  uses_from_macos "ruby"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modules@cyclonedxcdxgennode_modules"
    cdxgen_plugins = node_modules"@cyclonedxcdxgen-plugins-binplugins"
    cdxgen_plugins.glob("**").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules"@cyclonedxcdxgen-plugins-bin-darwin-arm64pluginsosquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
  end

  test do
    (testpath"Gemfile.lock").write <<~EOS
      GEM
        remote: https:rubygems.org
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end