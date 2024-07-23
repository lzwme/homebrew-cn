require "languagenode"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https:github.comdicebeardicebear"
  url "https:registry.npmjs.orgdicebear-dicebear-9.1.0.tgz"
  sha256 "011fd757daae5b79457451e1fb0dcf728305a1f87d1e801e7e89b921555494b1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6cbbf7216938ba5eb69b1ea2e85ca9a98652f06542b65dc95715f7ab31716a2"
    sha256 cellar: :any,                 arm64_ventura:  "f6cbbf7216938ba5eb69b1ea2e85ca9a98652f06542b65dc95715f7ab31716a2"
    sha256 cellar: :any,                 arm64_monterey: "f6cbbf7216938ba5eb69b1ea2e85ca9a98652f06542b65dc95715f7ab31716a2"
    sha256 cellar: :any,                 sonoma:         "5a3e1845030c961dcc3d7a3b6dcea9f2d0d63f808a9c6c346241a98d6c3bb00f"
    sha256 cellar: :any,                 ventura:        "5a3e1845030c961dcc3d7a3b6dcea9f2d0d63f808a9c6c346241a98d6c3bb00f"
    sha256 cellar: :any,                 monterey:       "5a3e1845030c961dcc3d7a3b6dcea9f2d0d63f808a9c6c346241a98d6c3bb00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be1e3833cee81fb13424e723ff7a4f8da3f5c97d731c6fc39c503839d7842c52"
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