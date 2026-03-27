class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.3.tgz"
  sha256 "b4097521587714f17ff568246d08843a0090d1836ddea6184876af97b95df482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "650ebfd7ca776f9d429df2c02ce955ebb4315b56a98169589147a55c641affcb"
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