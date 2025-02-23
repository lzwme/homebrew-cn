class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.1.10.tgz"
  sha256 "3a5601bcce58f2754a8e1b5b33b5edf906fa441cf5656fbbf5047851914e10e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2733db4b07e82430d84d556a4b0da38047f67af22533b6056bb8211207108c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a481bf6d70b5ef16bf87115ef4ec5a87893e31e35f3893a518543ac95db9542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dba288488e3223f3357f6028068fd27a94352c78c6f9c8d550f3990a0e2f7197"
    sha256 cellar: :any_skip_relocation, sonoma:        "36b130ed49edb3167042a700637e6c0f3931d284f1310f0b087005c8d1a67e6c"
    sha256 cellar: :any_skip_relocation, ventura:       "5236dbed07e523fb86adee73ee474cba37f3e6c925e5392a4915c3285a035a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aca2b4c803b939f1ee4a9c0e8f49dcb3687f32276ce9aa59f464f442667bc49"
  end

  depends_on "node"

  uses_from_macos "ruby"

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

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules"@cyclonedxcdxgen-plugins-bin-darwin-arm64pluginsosquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
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