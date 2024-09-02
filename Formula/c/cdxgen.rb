class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.6.tgz"
  sha256 "26cda2178b70ea88641ea7503c1f7d49dc7ac1c0875d184fda3c15b8e335c865"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4791d37d946cc3ed5c03761986e76a2a9469ae2d7e482a571018675f4b0ca0ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af207553dcaa47befb4f03565755cbea9109c52c4df57b0c82ecdbbad76788d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81e6e344eba5b9a575e8aeb773c79eabd1abc7776c2fb5e0be413690f811d4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9bf24161a3546aac713c2c45b544d340510341816ff4d9d785b775eaaed0241"
    sha256 cellar: :any_skip_relocation, ventura:        "559c59fa34e7dfba2b3e0ccffdd9faef2d48b7a407679e2747d4f0351cfe93ac"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1db6dabebd3a53bb813df15fa3917e1c647700da4a7e071a28584d3eef7241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf7794cfc9869dc2d3d07fd3aa946d004541aed652bb16a2e8eda15d93777fb"
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