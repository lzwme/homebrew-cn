class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.7.tgz"
  sha256 "00e5d4d3f5126ee88eb22bf68cd22dff165084c16b251a4a0769d86a169be51b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "701c03de38b40214b8978f31294d72850c7a4299707d18b03d36ebb046f86b63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ad9de536e0b7483d17da39ceef2bc7bd3f3cc08ca47f06a3695366518611c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "130684ad893859ebd19535475c75ed3cca1ee425dfc17bdbb65a515df1cdef61"
    sha256 cellar: :any_skip_relocation, sonoma:         "562849b4254f3fe2934e92f32082cd938f8e3b7be9e1c8fc86eb01aecf7d8db4"
    sha256 cellar: :any_skip_relocation, ventura:        "fe61865243687c520eb6a1f2983ab08be9d180563a8e01b9946c44233b23ee0a"
    sha256 cellar: :any_skip_relocation, monterey:       "50db4a3b21eb420d7b1582656f634dc8635664253c5d73a65505feee4dc9da0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954535bb400c7aea3a70c640d49b84d9b5c2ed66b6d06b03d9f8e64075dec49e"
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