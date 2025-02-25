class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.40.1.tgz"
  sha256 "829d7a5a14dfec8c5b6b7df7ce6b31581db2ac1614e5c2dd86ddd63ac4122825"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f273bef1cd4b8b2eaec11205a0a2dc79dd01b776b66f49deb2dac996cd6f70e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f273bef1cd4b8b2eaec11205a0a2dc79dd01b776b66f49deb2dac996cd6f70e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f273bef1cd4b8b2eaec11205a0a2dc79dd01b776b66f49deb2dac996cd6f70e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a536f159fbb0c2c9b6b48501e1453fb57ee614dfb210353abb7a2aa56a06a6a4"
    sha256 cellar: :any_skip_relocation, ventura:       "a536f159fbb0c2c9b6b48501e1453fb57ee614dfb210353abb7a2aa56a06a6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f273bef1cd4b8b2eaec11205a0a2dc79dd01b776b66f49deb2dac996cd6f70e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end