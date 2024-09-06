class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.8.tgz"
  sha256 "84d507200ce54c483f0109c936fb01c4abef73d8cc97812a0dafbc4bfe3cc820"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "f0f591c22698da7ace1f9a0df8ff8158a348fe356b141aa625d956f159c32caa"
    sha256                               arm64_ventura:  "8d7d6033a0208b22cd97bde1345af3d1a3286efe94dc91c09de30cc3006ae69b"
    sha256                               arm64_monterey: "d40d371a567e22491af68a7525522af753e7a75094abb84c7f61d0689d0de4c9"
    sha256                               sonoma:         "5e93c75567178d71a9a9fbc1add99330d3394c151520d059bf6d59e9cbe66226"
    sha256                               ventura:        "ecf2a765b8a49e76b23cf1409d7e5293dc30de793595cdf91fd6f10cb7ed2dd6"
    sha256                               monterey:       "15c89670436c8a1073afdee729ea4a658e53971dfc7fbcf8634fd123a871c97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4fb57b75944414cf08ae7d44f6045e366fc9c06b708a386d3e4700dbd9fdc1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end