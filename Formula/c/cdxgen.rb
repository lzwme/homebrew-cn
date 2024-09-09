class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.9.tgz"
  sha256 "c66a61da1e9f8adc2d0e89cba1e082abf04cacf376a4d1ff1ef71e5226a44ded"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cfecfaed77ca93546f7eaf26f990dfda0d5c9ee2a88ae1fb4266a6b260f2c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "074db48429eaedc119e5333ef11e8da8bb34e94bfb6e812b11e9f780ef30cb8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26eea8c106df64c57886db3848285cc419ffded93cf633e1e8bdd9285f9378e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1649ad49a99f97f0a95c3d58a3b9df0a8a6ae9007db08529ad2ad644de9a9343"
    sha256 cellar: :any_skip_relocation, ventura:        "11476f0494f00db8a5b24d83e7c808ce227c54a94d85b1fccbc4f0c5758dcdd8"
    sha256 cellar: :any_skip_relocation, monterey:       "e07b6edcd8944e745a0d1f21fcf0cc80ef627e61b0b296344957c066db7bd1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0511c00dabb4879879f8448963222c08f2075e2131a134dd794e1ec714d4148"
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