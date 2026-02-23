class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.20.0.tgz"
  sha256 "d54d2ccf20490b923255690fb53891f4b24c7ca1dc13481d303c9da0d4863932"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6761583155591036a91c13f2399b7939c484726ca5efaf4807206360e9ba6780"
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

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end