require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.1.1.tgz"
  sha256 "4e8d79c831885e1051cfeaca9092d83b327d0f1b3d7a3097650e542542c5c232"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d090b641a8cac4a9b38abc73a3d1575a5fee924038d6594554c7ffc8efc947d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7733b719813e96fd1fdd9b039e2e5591b10aba95ef73e8090726554be426d16c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58373002118d80a5a487adcc3e879e4d85b008a32b5673f91521443431f8d975"
    sha256 cellar: :any_skip_relocation, sonoma:         "98aafb09c3d620fb868c584850bfaa5f1aba42ca0087857bfe8de4ea5b23b1bc"
    sha256 cellar: :any_skip_relocation, ventura:        "3ef1513f253e888b34d220a3f8b2dccf1b33b356041ffe311fa107e6bbab53c7"
    sha256 cellar: :any_skip_relocation, monterey:       "d6f14468009ccafbea5aee5eabf778f1349e229421799aba0edd1b16d0e17313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63a7a45d8d50a1668393bb28e452f77e023d30620128f5be7347a358701ba80"
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