require "languagenode"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https:github.comdicebeardicebear"
  url "https:registry.npmjs.orgdicebear-dicebear-9.2.0.tgz"
  sha256 "89c201ad0012b71f78ec501606a83826d5d735855159a29e999c73f7b0c88b0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e4e11b9808887a2f5a0b81f3cf0e17675245ba37e449262bcb560930d06eb32"
    sha256 cellar: :any,                 arm64_ventura:  "3e4e11b9808887a2f5a0b81f3cf0e17675245ba37e449262bcb560930d06eb32"
    sha256 cellar: :any,                 arm64_monterey: "3e4e11b9808887a2f5a0b81f3cf0e17675245ba37e449262bcb560930d06eb32"
    sha256 cellar: :any,                 sonoma:         "86911e6dc746d5cc33101c8ca1c2c2611a0d4e5f2117b3bbe2f3d3501fa76ed5"
    sha256 cellar: :any,                 ventura:        "86911e6dc746d5cc33101c8ca1c2c2611a0d4e5f2117b3bbe2f3d3501fa76ed5"
    sha256 cellar: :any,                 monterey:       "86911e6dc746d5cc33101c8ca1c2c2611a0d4e5f2117b3bbe2f3d3501fa76ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68d5c5d2380bb48b0ccdce702ce7b52a83b8e40c2041e429d56f0b942f4abcd9"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    node_modules = libexec"libnode_modulesdicebearnode_modules"

    # Remove incompatible pre-built `bare-fs``bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}prebuilds*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}dicebear --version")
  end
end