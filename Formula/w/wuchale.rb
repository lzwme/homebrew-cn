class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.1.tgz"
  sha256 "5c4d0abe668b1490b10ca9bce42e6c22042e6f412f14d6cd58b2ee511d675fc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54df2124f7770ddcfa76d8e5e4a585ca23ae5d4dcbf6f58a4adb832bc55fbacb"
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