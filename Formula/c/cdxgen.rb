require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.7.0.tgz"
  sha256 "a9ebddfc07596686846b2876d5e8e091ed7a34c8b2c7ce711586b1963f6eead6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "675338c64f56129ca92770f529255c7bd03a73c58da150c4dd54c0d35480c173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "310fe69757958d81f32b000d2f0668615131e48e2d983e2c61f058f60e835f27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d30406ac664ef79ec80c5a3b92937457fbc050c2ed1082be42e6076e3dd883"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b519abde9e3ed9fe3b5d61c94b7d6e60ec4628cb0af932fda99ce20751ed32d"
    sha256 cellar: :any_skip_relocation, ventura:        "f15e80ca3f09c6b0e9f887f63e2e54e052aaf02adafe9b7cf0aa920e7730bcf8"
    sha256 cellar: :any_skip_relocation, monterey:       "480375377fbb0c0fe08282f12e6f609b8525b4f149afea40c678271f555ecee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c35bf27589fa331df109dbe6fca93f86934718c9b2de20147b686fe75a4aee"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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

    # remove pre-built osquery plugin for macos intel builds
    osquery_plugin = node_modules"@cyclonedxcdxgen-plugins-bin-darwin-amd64pluginsosquery"
    osquery_plugin.rmtree if OS.mac? && Hardware::CPU.intel?
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