require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.11.1.tgz"
  sha256 "b7c107c79b0fa52fb16bcf409797ebec01858a2539d133813106095c78c471b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6437ef4a17c1638ca94fec5d7a1aac3fae4dbd0548eb90b18183c72b8c2c2aaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdfaed6196733ba238a83d683b2771fd8ce13b1ac1b99f07ec3e157ea3cd57f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e44c61e9cc29461555ec57f2ba4038381220910453887b6db5f4f58682741d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "9608555c2e3140dbed532172627c104d7a1f4fad1989ac8bc17a8b70242e5234"
    sha256 cellar: :any_skip_relocation, ventura:        "158d2cd6131b63f93edecb7b253ccc522c0b826d1c3adf6703040fc33363a4d1"
    sha256 cellar: :any_skip_relocation, monterey:       "ad4ed54722351cba4cc7481d1e6a470c378575627b8ba8e30165e818c3203688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21be6843f19becc3ca1b8403fadab024089efee015b8a4ab4e909676bc0e3353"
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