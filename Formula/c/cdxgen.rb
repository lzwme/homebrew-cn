class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.1.4.tgz"
  sha256 "46e4e3886b408ce147f5aaa48dc511054257ecc58d207b8c302205fc42c34b67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf472f82b49444a21ceba7502f8afd6a481252fcae37e73697265c20bca7bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d24e20d55e9bb7d6244ce91636e8bd38872ff400e5d0e6b16eba8d9373cd3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d7a41bf18e53e538c7c7246f39104221ad98ae47519447c0bab5d33fb97fdbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b3fcc933ffd70b2a16247c8ff05f66081891f389f0c7bb5df6095040175ee4c"
    sha256 cellar: :any_skip_relocation, ventura:       "60b41b8758f131ea7c58b835b591193d2be87b29d37df1c178611283ba7f67aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9078fe9d124ee312a3d4eae661d3afc54a2df0c727dd92e7620e0df2a60e58d"
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