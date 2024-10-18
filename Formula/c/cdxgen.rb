class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.10.5.tgz"
  sha256 "c3bd8bbedd82acf5cc40d9aaf9ab0ddbb4412167f059e94e91e2870c767d42e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f16f376444604d79eee11f1f075ab058efbc630daef78bde73d64f6bfa9f77e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc8d16cb32dadf515c15bb2051baf119eb7b801994ac45cd0cd2a55378149ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9a87d090438bd734e79766c620adbaa99fff7dadddd6f3c125bac3798d0ffb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a61818a928ac1ad4e08b5d35ff304db8478f6961b04febb1cf5b5a440cd7ba32"
    sha256 cellar: :any_skip_relocation, ventura:       "8c2f82233ef7583b4a04e908599ab3ff8d6652ca405eec7c2f4ca48511232bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd4809e5a5fa191e56a93fe6e3df5a8457a84050d52cad25e2f51862c92e28d"
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