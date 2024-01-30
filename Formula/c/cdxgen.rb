require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.0.0.tgz"
  sha256 "02e68515bbb4aa2c49febd3cf3a706d0eba744641b1fd2748d0fd9bdaec3b677"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14cdbded2b352b80e2a706ba8e600b5ea3cd48e9001bb850093cd3343bdd1539"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f64f55569a56ad428216153153f17b38eacb1a1d0d1e46e8b48349084a1cf1e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a909e868ba7a32b45b762c59bb8255198d87d6ae51bd045dacbd7c722f12b10"
    sha256 cellar: :any_skip_relocation, sonoma:         "7468254471471280daa3865bed89d62d32fb81c8c2adece88a646360ef835c80"
    sha256 cellar: :any_skip_relocation, ventura:        "ed14f7142971b94280c7b69ec5cfd2cee79085607aa4ecda830a069aff3d8f82"
    sha256 cellar: :any_skip_relocation, monterey:       "f79e8333be4fc5dcd951073eb8db24045944c8ff209ff32e97e3a0ae9d3ae5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c1b650bb9c3d11cf69a348795579ddf9ccb94d9b0855a899b3ed30d2fe6c7d"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end