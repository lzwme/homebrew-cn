require "languagenode"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https:github.comdicebeardicebear"
  url "https:registry.npmjs.orgdicebear-dicebear-8.0.2.tgz"
  sha256 "98b48c0478f6efe083c5b78e6e96e19f746216ad4d19a95a18f3bb1e7649e849"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "cc298c48312046d2c6820249bc140ed8aa3a265ab48701c32cbcea2ac078a78b"
    sha256                               arm64_ventura:  "eea0aab12d9b01516c4e19ab7c17af728b9b19dcd6248862abdde8c7728fedaf"
    sha256                               arm64_monterey: "5b8ea176b26f7fd684069975b80fa2c905a94c01e6e0ffcefaff03bc727f7c3a"
    sha256                               sonoma:         "e1a9f0da0ad85c2c6a34bafc4e9221478612a075b115604877734ef57aa2762a"
    sha256                               ventura:        "ed50b6f711943d9d2f6f1ad65416e9340ec5e67caf3d48370295ae7b3110e7a3"
    sha256                               monterey:       "00a555df499f7b303ab27108ba7c6bb609eae7f95fd16fae6b6d629fcfb96c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470295830220f99c66f64626abf5089ab89809c876a82a7dfd5f831116d5dc51"
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