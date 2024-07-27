require "languagenode"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https:github.comdicebeardicebear"
  url "https:registry.npmjs.orgdicebear-dicebear-9.2.1.tgz"
  sha256 "b837106ca2dc746611f0926d8faf57182d06294e7a8450139e34de5bf7bd25f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91aec5fd7e75f6a161668097fd4fa6f54f32c4e3685130b4a54f91b831fea9ac"
    sha256 cellar: :any,                 arm64_ventura:  "91aec5fd7e75f6a161668097fd4fa6f54f32c4e3685130b4a54f91b831fea9ac"
    sha256 cellar: :any,                 arm64_monterey: "91aec5fd7e75f6a161668097fd4fa6f54f32c4e3685130b4a54f91b831fea9ac"
    sha256 cellar: :any,                 sonoma:         "af649e54fdf8f9294e4543e5c286340cd59de18a6a01befad2bfe5fbbdcf1ed6"
    sha256 cellar: :any,                 ventura:        "af649e54fdf8f9294e4543e5c286340cd59de18a6a01befad2bfe5fbbdcf1ed6"
    sha256 cellar: :any,                 monterey:       "1e55eff8926e24ab415c892a43edd2f623a58f632cdd9da92892592fa93a24be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ed81281a4201b1f6c8c79603749ec74db5e5c83d4d2bb8903c3305ad0edf29"
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