class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.0.7.tgz"
  sha256 "7e3bcf6c476505ebced50c34491796a6630bafa0fa91d67765183407086a8518"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69431904ae343aafdbd2ef621db7fb61bdbcb533307d71ddf0114c097df6f0c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc80a8597030bfc88730e8d9ed04cd40f03ff9df79ab59e6b5318ddbfcb5019"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "505b678701cacc4b030ba7ca4140b367c020d2dea7935344c55b8d0378f68f1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9442c4adfadb4a73a90226511b54474cb788f21bf3347dfaa3bd8f22578db879"
    sha256 cellar: :any_skip_relocation, ventura:       "0cdffd1e23b46abd7d7acf30a944732878b02cb419ec999d4049be5491b8e21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802b6a412378489319e14569fddf32814f42922074b01655efebe99a6bc764bb"
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