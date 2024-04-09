require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.3.1.tgz"
  sha256 "6b28887c4a663c247710956296f59d2a2617a78e3836ba25bd5a8c3f4928161d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "140a4cba195ea2024809677c2f0a7250df8e1f17c344ff757cd10b351c6bd808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e2e008e9819761a78c26a816cf276a4faf9808a40ca8254157566a6e5458bcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00b683ebd782497e2bc03831a591583e7a3bd29c4675731e7aebf464add3a254"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2a0ddd8a3765cb49ff895b5b299ec9fa87f01187506ad6482a4d96656ee2301"
    sha256 cellar: :any_skip_relocation, ventura:        "bb80ceaa182dd287cd43d684320fd71bb668103b7ab209f1e3da31943caf1c31"
    sha256 cellar: :any_skip_relocation, monterey:       "629d5fab4f59ca750ce8ed79d78804fc18b261a74d58f56475ed29c96f391b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ba6c7d7cadcc05f69eb1da07fd086243bc5add64da2979cbc55bd8340e4a98"
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