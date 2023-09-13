require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.7.5.tgz"
  sha256 "2397a4cd60ac48b4153ab6ddf23b927cc2ed9e6c386fc7c9e3f061c7b641ddc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef468a25c342729a71aa6e615fd96be6c8e419641f25f9b83baf8a2613315776"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0869313a32c9397b6b33c5f13dd90757658ec48068df843fda93d6ea549439a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ec54fca9323868c5d1b27ab23d1a84156940b3a4a3d980557f967509ebffeac"
    sha256 cellar: :any_skip_relocation, ventura:        "71e0a5b9adf50316b43deae379efb725f0adb4289847b9f161d52c002b2c9212"
    sha256 cellar: :any_skip_relocation, monterey:       "145b7b7bfdb2f340229f0c0d63da1fd446c10de8ef8811d599922f72360f80b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "28e02efd8ed8f07cc56cf8d373b7c5c9dc11252f4951d15fa05e47991b3a5805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c6edb31da041a7b553788f2a5990f78e0588cf8aa20aae90b09631b5c92c6a"
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