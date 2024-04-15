require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.4.0.tgz"
  sha256 "e55519953ed919e94e8f6ab53492895deb6fd9c4a8132eb28297aff6e6eaee46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d068d01775a12b1116cc5e60accc685fc1578e9a1ed7397c138ab7d27a8558e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f3fb0a893bad8f487b0d514e530cd11c9a7efff62f8eb3b010c3827302a2093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b41fff2fd93fabdc74c6420b6c9529f8da83b245cd2323007226de4b6f1226d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dce214acc8c1ce28da1b9c2cf40418d4ec67efc8b9192ea10ebec2914576af14"
    sha256 cellar: :any_skip_relocation, ventura:        "d64722ab9f41461cf7915cb419f2fadcd67bd88d6ffa4c84dd7844ddbe544be2"
    sha256 cellar: :any_skip_relocation, monterey:       "c26ddcf0d9d68c408046c0e4d9cc4ac276cd160fa4a3d7d9ffe4eb04e7296651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b17a8b1bc48a80de762e6db656aa591428450160856554810cc7f315f749dfa"
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