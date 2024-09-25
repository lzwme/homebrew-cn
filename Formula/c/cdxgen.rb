class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.10.1.tgz"
  sha256 "2c9bc25808d284585c3973860489a916de15597922a0da9b97052d50de6eb18c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1d6a5ec1c96c9051fbe0fe5d3bf8d8d2d4e5287dfafd72dce1cfc2848f2ac3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cfc929ec2140723e63916ef116ea8f01e8fe631d3a817689682ccc9db115a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c9eb92ca39ab78bd9fc49734308a50ce7c5bb2f73560d51ef8b53aadfb2a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "241911792f1e144af07667df83b0aff47fc9708cff875bf3b8978387181c4b1d"
    sha256 cellar: :any_skip_relocation, ventura:       "227cc4f86cf6839ef589b618eedf5c69310e2e4bef131258d6d023096d8e7a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe2ee996a3b2585aa0e5acfd24e0b2394ce0e4f16f715b547e662196e7817c4"
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