class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.0.tgz"
  sha256 "4d4f393bd2eda52a2af3da12347ab4062313e033de4ff5073627cba31336fa16"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd4d58b900745a026d4c56235b1098df82ac5526c240deebd2bca1948e9e1c91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1200be9b8b6a95d73bc1f17c2e06a8f0a7ab4eaa8e391cfe1817879afc963543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47685083e548db74c2ada4d420412752dac0ca2efc9b85907c60df9d8fe88469"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d22c758a1fd4b37fbbe6fa5bad00cd1d0b9ab7c6f6dd005ea1a58a0f4ed4fcb"
    sha256 cellar: :any_skip_relocation, ventura:        "e61bb5e1c43f9cbb0aaf460ff33710d22ac98b8dbd6f187359759625b8eea755"
    sha256 cellar: :any_skip_relocation, monterey:       "db9cf65243698779468a8ff953f5ffcfeec2e96dc5534e447c89cb44dad7b2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536a0ea0536208010e8d06cea42c4d7911b6d98fe9d91afb31f63c16df722a7b"
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