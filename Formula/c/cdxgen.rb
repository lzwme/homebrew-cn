require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.8.1.tgz"
  sha256 "61247d7d6bceb19fa66f731ca968bb184ee1df00af8eecba8b4fbcb1a93444e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88ab1815d56a8718808cb3582a6fe9bcd2c16b39dfdf45c209c66d42a16d391c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec381ab4517ee731f91a59b13641b70046b5313b882740eb7af0542798d09573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c30861a34a49712ffd311e48a1199025f3e23e1473c62a336101e44d752498a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f0051e054c3892866969d1c6b3806e0fc34bce88874d678d3d84139eaa38514"
    sha256 cellar: :any_skip_relocation, ventura:        "690765b3bfc2a762f3d0005e11a9361182d2dd6b7920d8baff34541eb2fe5c4e"
    sha256 cellar: :any_skip_relocation, monterey:       "7204c21212f4afc150e2579d65441a6721e7396c410e19ea5256cedb5dd48b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "115546e196ec429c7d4f98c622c73edc9fd298be6bf6f179c8ff284b5ed85b77"
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