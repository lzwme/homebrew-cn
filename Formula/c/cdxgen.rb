class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.4.tgz"
  sha256 "20ca4ac582570f134e6cc9c1b1e0dd5f4942de038c8cc6343e267ba61a606b9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbd7e12a4cb6f6b477d44d0928f702202d321556410cde5f856947af7dcec235"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e21850876dea94cc024f6b06203f34d319bd14e466640a896316e4e8d2c1f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77cab3942e6a28e99d7b552981952c1478960482a20c017c9bd6fce390c920c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b65e4cfd37d1fa7a72e3231f694c1eeed6bc87856ce8cca2e01ff8931d0ee412"
    sha256 cellar: :any_skip_relocation, ventura:        "2ff4062e076ae245ba871199f6d179443898eb68e4c6551aa13d74a3f2276e01"
    sha256 cellar: :any_skip_relocation, monterey:       "4a7d5a9de72f89a30fee250f0e504f993be77f4d403f37cf3e36e3082f1aaa2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ab1018e29a239dae97deca965a2fc04a8aa18d44aaf09d0b12108bfa42c277"
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