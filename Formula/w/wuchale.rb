class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.4.tgz"
  sha256 "c4a1603f5cf8c9fccc4eeb5e9cb2fd1fcea97066625a6a6f89932e1339119f36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6add0aa4613a5077750ef48b41f89a152934a1fa733db5d19b72e40ead07617e"
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