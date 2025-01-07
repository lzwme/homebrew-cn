class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.10.tgz"
  sha256 "8b23c8d7c0c7d2d4a9585ace86cf3803e4f21df972ffb830bbf92ef3e68194b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484bf5b50a962e8a2675d99b8fe6dd6d156e39c79ce2b064009f8767e3a5b688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f34e8b2f1501e446f55da40842743e590b752777677c8c785f985c3bd3f1260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "061bb2e160091fe40a21e514cf7df5bf5d853e6aaf406a6844d46d2ed1757fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddbb67f5c0f96f54888799e601104e746f26633e4084655dd2d7a6974bfa058"
    sha256 cellar: :any_skip_relocation, ventura:       "a7e77ad869a59ef4f7ed86654216acf10347e3b3e8d99f736be5c6d7f2247689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307568fcf2426432b90623712c58a7f3cb5281b997722cc6aad828cb09927428"
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