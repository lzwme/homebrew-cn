require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.5.2.tgz"
  sha256 "f779698db3f61b9f555bd81103ff27dbbb3b88c134d192300dcda3caeeb21e84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeb500f31de0ac4999b055bf80fc4652f3318f1aa4f5a2575b4f1613a2bae317"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15361b4cdc6384ba7902d5dff94581540aaba6c1793b2026477b6e618fd8444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3705ead4bc419ef62dccb0232f5447fea786e3549570aba6aa8db3744f793760"
    sha256 cellar: :any_skip_relocation, sonoma:         "17b9003576ed858fb45c1885c0079c34f721558e5ed3b5782fa45b78221293f0"
    sha256 cellar: :any_skip_relocation, ventura:        "bcc0d11a870bf72e956807bccf66b2bdf17282cbc7101b68a798553399c1d7fd"
    sha256 cellar: :any_skip_relocation, monterey:       "481cfcda4dbde88410599375e24fe07cd60718cf7a99ab6d31fd0cab9d188d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "842436b3d7c1eaec3d562f7824666995d2c9f3ddc5c20149dc89f323cef122e4"
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