require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.7.0.tgz"
  sha256 "8ef0fa6b5d3a1ecd81f58376a5503e1b63561e10d1ee1e26b4eb6bee261a7c30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1f5322a278868283028f38f517be837476ccc6bd3653b9535a62b769976be94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "845d9aa89dda48d1ba65926fb8a3fdc6edc9deba86883bbbabea90259b9d28dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d95155ff6e20ea6e8e2ce89a5b703bc7d8ecdba455b9f8cda795885ad1f87d96"
    sha256 cellar: :any_skip_relocation, ventura:        "cbae831a4151132c7785980a697ab2a6b16f9b69063bd23690329520df202b87"
    sha256 cellar: :any_skip_relocation, monterey:       "96d599eed89dfad79b88cbd1b0621574cb9e8519de47a51d8ae7277cf8bf7a4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaba3cb6a14b3c750a1cb6b339efb9d7970cb1ff5ee1cd074294fb74f7a366a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc159c6d31a442c7a52bf1b52ea242f216a8dcf5c6aa312fb686c4e8fc4e1dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end