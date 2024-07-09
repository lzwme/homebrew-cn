require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.8.0.tgz"
  sha256 "b434db0925e98a961fb138b5f97762511112a09904b5e281b9d1e8108458e61b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf84cf4fef388fd5377abf3b97430929f9ab51785079a2a7373e5686e7fcce9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24545ea79d9ad9a98ba46af57fa7fd45201945a133e2049192898cf171b6c02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6dee6753dc73d6d6e500fc5601f50a95ebbd675b3c80d655284d69351a9889"
    sha256 cellar: :any_skip_relocation, sonoma:         "29dad227c8d8deb4af2386960aa22203e1d27fb5da5a8cf32a5de31c1139eeec"
    sha256 cellar: :any_skip_relocation, ventura:        "700128cce3fe890cf56bcc2e2f28f3db117cc8be264732c7e4a69fc6aff26b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "9f422c8dd7cd97d17330e1be6547d7c693c7c3604412d252eff23e0404c597c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed01cabab44e6662ec2f41883b37f32d73e7b91653a83dfeb9373880c6b834e7"
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