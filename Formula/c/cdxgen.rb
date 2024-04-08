require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.3.0.tgz"
  sha256 "dbd4723f52470418668c3f14eb83e192f231ea474a77558148b88d7138a15b38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f553b6cc045b8244c5ad0bebdc11d368ec4f0a9a05b991c12a8708b9115cbe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e330293075275a1e603ae47fd14ea75e3e00727052aa342c99426ae76ac91adb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a2460e9f90e352e6b5c11c75bcbfd5ae85ce768409aec715ed91f01353a1878"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bcb4aee710341afac5a0394e43b38fa861a24af1d7ba318bd34d69d935124dc"
    sha256 cellar: :any_skip_relocation, ventura:        "d2252392da053f84e8125548ea87644cacb62d57a2c6d183c45c03e9b378ea32"
    sha256 cellar: :any_skip_relocation, monterey:       "d5daf0449b7cf83ffe9763c14ed3a8b7d0d37e315738cc0726653ece661bf209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8070babf8014fc560c9ff501d0307127e347492a3b6d7df41d0ec8942bbdb2d1"
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