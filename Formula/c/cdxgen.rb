require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.7.1.tgz"
  sha256 "5eef7fb75796e29f484457d44ea8e92953c58ba648058634187741d5d429ce59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66f37bd0fe9bef4cfa09061f50e52839055eb46f334bffdab07ad8b6a068fd9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c7ad899bbfcb36e8a58132e2b60af3bfc904b3577318c01562ab1592531487a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6084fbbf5a1ed5299c987623ec9b32a3f33ab6bbd168eb8ad125d800f328ca18"
    sha256 cellar: :any_skip_relocation, sonoma:         "772b30294d2e800e58ca83825eae82932642251cdad06e864ba5904b62c0720e"
    sha256 cellar: :any_skip_relocation, ventura:        "77078d73b397bbd0f3a31cb6b748ac605ce174f7fe1cf2ba24c66700df7ab2e8"
    sha256 cellar: :any_skip_relocation, monterey:       "2ffd0c1061e4b4408a831e486dc65c5cabcaf481091ddd2f6f8e8432b29aee29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fea77c314d59dfa2590ad279320e2f7d04cdbef6636742de4c885defba468ef"
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