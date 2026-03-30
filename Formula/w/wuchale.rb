class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.6.tgz"
  sha256 "67a7360b5f02d9449cc5e30b617fe719575b700b5e5f9b088af3146963487fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9fafce814b82eb2d449035335074039425ae70778993321cb2b32d898e8880e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end