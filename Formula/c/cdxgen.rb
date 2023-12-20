require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.10.0.tgz"
  sha256 "ec639880339c3d25d3eaac373702390cc2e1e611125c4f073c4f8f5271cecfe9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bc08154954bd2dfc561aaca8a93a70794f0da2d91873b3327acb58f7a9bef78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb3722286a94460ec75f64ca5554766162ce0e6cb91e92661df66395f06ec02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b496c69462f2ba4a8828dc856c60abafd16fa56b9403fcfe63b0bcb1d5c9808"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f20be0da276b05d9c7a3592fcbac2c4353fc8a039d5187245786ba4eb7220df"
    sha256 cellar: :any_skip_relocation, ventura:        "3a48dd67f6c589e03be1a6fd614de5482dbc979a60792f39ff3f18697a69a833"
    sha256 cellar: :any_skip_relocation, monterey:       "328961e6b0fb88cc360538cb659fa7efc5f697f06dbf618926ca7f9d858baefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9732dead49068534a13f6b543ea0cd8da23714c1602ca85286b2255fcfab77a"
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