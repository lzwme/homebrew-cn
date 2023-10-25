require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.0.tgz"
  sha256 "fe2315368ab9f0ff90d2b89005aaa130647052ee9d181cd1371c45ff0ca1d543"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b5414757655dfa9c5f93a3fd976ced4985d595e7fea12e656f2ca85ca945d6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8dc4f2f44b9d6b7eb6a37e937da92e8c8930924e86ea39a7bdb6a9dc524097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e432f3a84056cdc2f07110c66f6755affc49ff194e99de57ae03f98a081c7ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "d017d4341c4c92e08a2b19fd1d02625dbc27341bca501703cc45d6682823f3c3"
    sha256 cellar: :any_skip_relocation, ventura:        "d6db767f1255ae7cea35eb2690865e94041287d8dcf4bca1fc5c93b279718dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7c2736be0d5a07701ccf1303c43b6b50ac00d982c1de7065eeb514a51871bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8947ec586a06d481160b156cc5ac50a4793fab57233753d3b44c2c1a0d2eb53"
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