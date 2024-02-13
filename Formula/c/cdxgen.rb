require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.0.6.tgz"
  sha256 "da70d9bfd25723604df61d81ff2d6a7a41ab0cd42e7dea5cb422bd05a3a15321"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3617686fc33d4f9bda8476056a91cdaf59019e142c765af38ea7b39cce9b45e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2173f638892a2ced4953e712d0c9d4b0a4a42aedc6607331f2b84fafbc980abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "205ba5aa3323b8228a3ae54a6a138b57d98f17ced350df1f4385a0692b16c4a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f62d493de8264c31b2da0bea78ee2399de0763c52894eac7edf4ed775734fac8"
    sha256 cellar: :any_skip_relocation, ventura:        "1141c061b15eac6ad5849fe6bbd753b798630434d633f96d95c2c3f5d7e14cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5807750dcc252de70f9cb0941f80f9e13c0e4a72d409d0a6f7bc0590cea8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b55cef7069f9cf1a952d90c37f14a456bcfc668af6798ee68b403ed2fe24277"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end