class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.4.tgz"
  sha256 "c9979d7bf3b393105c69780441560e6ad68429bfcdd8a7bf70ff7ae6f0a4ef35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17bfa843721f10de5ecaa4c072617d2965809da98637f9dd9042d6643f159f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc13752885ddd70401343e7bbb53bd4d4b9dfc53dc5bd4acfe626cc45cb39b56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c378c286792a505022adbc171fb2b65ceb826d8b3cf946cb21bd13621d5f7976"
    sha256 cellar: :any_skip_relocation, sonoma:        "172a8b7aa4345ef56e04e85f4f820b85c4c00313e63df7cc9e6d68fb89e36687"
    sha256 cellar: :any_skip_relocation, ventura:       "2f0f5eb94dd698d87db99859ef929dd6bb3bfb655688e431e9ce8b1afffeedae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a402da4558fe323c8f1e7a6f084732ded859ae11fda9d56c3b51a7b713f9f6e"
  end

  depends_on "node"

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