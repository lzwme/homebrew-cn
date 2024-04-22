require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.4.2.tgz"
  sha256 "36a6a04c653585b0861da6d7e78d35da301c94f93a664ff56cb1da05078d0169"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62831db39d002af30d46346d4135066cdb5384383f78d0ad0e8fa73fa70be3d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03b4a8aebcd5f0b17c769cabfa9d71e4fdfc5e41311bc5f3b1cb3fb35526da3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6f0a4ad574760953d88dce366bd4ffddd7fd9a19b32899844e5089322bde19"
    sha256 cellar: :any_skip_relocation, sonoma:         "8afd87aa847f78be472a22035b423ef69884ebc2ec42f161ee2cc358712f7cff"
    sha256 cellar: :any_skip_relocation, ventura:        "efd40450234d2478d573ac51f392f699eca47ccf6cf0e3a4936b301e6b21f993"
    sha256 cellar: :any_skip_relocation, monterey:       "575ecc36ccf4d711d981efcb830adf5ed9c6be592425b3e6fe035e8fb1afe8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546dfe137f80104920381fc97a6e710038498d30e26d4c4845148fbe38757255"
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