class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.10.7.tgz"
  sha256 "c40b0565435c6672064c16c2651efa9c8a5528139a4fb413f36ef331b1c5d620"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1abbb772717487d2a5079ae9d2a22f2be50d6f4b9cc75a59b7ca1375801f55be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d9674ba8a4290621b03ff6f68815872c3449c9152b11667fff83cfbf5bebdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a4fae10dbf55d6593cddebb371065f651bd65464dcc0987e01ba90341400a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c80a415caa583f80b3d9cf145b1652156511d1ed9ad33063df92cf5ba5eeab92"
    sha256 cellar: :any_skip_relocation, ventura:       "d6be014450f6c1fe7a183229fa56feca18a08b1e37d9f93c26220c667da2936a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d851d2a7239d266354174e7cfe81fc0136940b9c0e7a0d33483d4234fe84be40"
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